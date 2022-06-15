class Player < ApplicationRecord
  belongs_to :sport

  validates :age, presence: true
  validates :position, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  before_save :set_brief_name
  after_create :update_average_position_age_diff

  def update_average_position_age_diff
    average_position_age = sport.players.where(position: position).average(:age).to_i
    sport.players.where(position: position).update_all("average_position_age_diff = (age - #{average_position_age})")
  end

  def self.search(search_params={})
    query_params = {}

    if search_params[:position]
      query_params[:position] = search_params[:position].to_s
    end

    if search_params[:age]
      query_params[:age] = search_params[:age].to_i
    elsif search_params[:min_age] && search_params[:max_age]
      query_params[:age] = search_params[:min_age].to_i..search_params[:max_age].to_i
    elsif search_params[:min_age]
      query_params[:age] = search_params[:min_age].to_i..
    elsif search_params[:max_age]
      query_params[:age] = ..search_params[:max_age].to_i
    end

    if search_params[:sport]
      query_params[:sports] = { name: search_params[:sport].to_s }
    end

    if search_params[:last_name_first_character].present?
      Player.where.not(last_name: nil).where("SUBSTR(players.last_name, 1, 1) = ?", search_params[:last_name_first_character].to_s)
    else
      Player
    end.joins(:sport).where(query_params)
  end

  private

  def set_brief_name
    self.name_brief = case sport.name
      when "football" then "#{first_name.first.upcase}. #{last_name.titleize}"
      when "basketball" then "#{first_name.titleize} #{last_name.first.upcase}."
      when "baseball" then "#{first_name.first.upcase}. #{last_name.first.upcase}."
    end
  end
end
