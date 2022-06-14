require 'rails_helper'

RSpec.describe "Players", type: :request do
  describe "GET /api/v1/players" do
    let!(:baseball) { create(:sport, :with_players, name: "baseball") }
    let!(:football) { create(:sport, :with_players_in_same_position, name: "football") }

    it "returns players" do
      get "/api/v1/players"
      body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(body).to all(be_an(Hash))
      expect(body.first.keys).to include("id", "name_brief", "first_name", "last_name", "position", "age", "average_position_age_diff", "sport_id")
    end

    it "returns players with the same age when age is passed" do
      age = 25
      create(:player, sport: baseball, age: age)
      get "/api/v1/players?age=#{age}"
      body = JSON.parse(response.body)
      expect(body.map { |p| p["age"] }).to all(eq age)
    end

    it "returns players with same age or greater when min age passed" do
      min_age = 30
      create(:player, sport: baseball, age: 40)
      get "/api/v1/players?min_age=#{min_age}"
      body = JSON.parse(response.body)
      expect(body.map { |p| p["age"] }).to all(be >= min_age)
    end

    it "returns players with the within age range when min and max age passed" do
      min_age = 25
      max_age = 27
      create(:player, sport: baseball, age: 26)
      get "/api/v1/players?min_age=#{min_age}&max_age=#{max_age}"
      body = JSON.parse(response.body)
      expect(body.map { |p| p["age"] }).to all( (be >= min_age).and be <= max_age )
    end

    it "returns players with last name starting L" do
      player = create(:player, sport: baseball, last_name: "Manning")
      get "/api/v1/players?last_name_first_character=#{player.last_name.first}"
      body = JSON.parse(response.body)
      expect(body.map { |p| p["last_name"].first }).to all(eq "M")
    end

    it "returns players baseball players when baseball is passed as sport" do
      get "/api/v1/players?sport=#{baseball.name}"
      body = JSON.parse(response.body)
      expect(body.map { |p| p["sport_id"] }).to all(eq baseball.id)
    end

    it "returns players baseball players at a specific age" do
      age = 20
      player = create(:player, sport: baseball, age: age)
      get "/api/v1/players?sport=#{baseball.name}&age=#{age}"
      body = JSON.parse(response.body)
      expect(body.map { |p| p["sport_id"] }).to all(eq baseball.id)
      expect(body.map { |p| p["age"] }).to all(eq age)
    end

    it "returns players with new average_position_age_diff when a new player added" do
      age = 100
      position = football.players.last.position
      player = create(:player, sport: football, age: age, position: position)
      average_position_age = football.players.where(position: position).average(:age).to_i

      get "/api/v1/players?sport=#{football.name}&position=#{position}"
      players = JSON.parse(response.body)
      players.each do |player|
        expect(player["average_position_age_diff"]).to eq(player["age"] - average_position_age)
      end
    end
  end
end
