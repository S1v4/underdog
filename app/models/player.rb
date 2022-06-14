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
    query = "players.first_name IS NOT NULL"

    if search_params[:age].present?
      query.concat(" AND #{Player.sanitize_sql_array(["players.age = ?", search_params[:age].to_i])}")
    end

    if search_params[:position].present? 
      query.concat(" AND #{Player.sanitize_sql_array(["players.position = ?", search_params[:position]])}")
    end

    if search_params[:min_age].present?
      query.concat(" AND #{Player.sanitize_sql_array(["players.age >= ?", search_params[:min_age].to_i])}")
    end

    if search_params[:max_age].present?
      query.concat(" AND #{Player.sanitize_sql_array(["players.age <= ?", search_params[:max_age].to_i])}")
    end

    if search_params[:last_name_first_character].present?
      query.concat(" AND players.last_name IS NOT NULL and #{Player.sanitize_sql_array(["SUBSTR(players.last_name, 1, 1) = ?", search_params[:last_name_first_character]])}")
    end

    if search_params[:sport].present?
      query.concat(" AND #{Player.sanitize_sql_array(["sports.name = ?", search_params[:sport]])}")
    end

    joins(:sport).where(query)
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
