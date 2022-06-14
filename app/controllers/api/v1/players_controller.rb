class Api::V1::PlayersController < ApplicationController
  before_action :set_included_fields, only: [:index]

  def index
    begin
      render json: Player.search(search_params).to_json(only: @included_fields), status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show
    begin
      render json: Player.find(params[:id]).to_json(only: @included_fields), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def set_included_fields
    @included_fields = params[:fields] || [:id, :name_brief, :first_name, :last_name, :position, :age, :average_position_age_diff, :sport_id]
  end

  def search_params
    params.permit(:age, :position, :min_age, :max_age, :last_name_first_character, :sport)
  end
end
