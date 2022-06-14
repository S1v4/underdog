# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Sport.delete_all
Player.delete_all

sports = ["baseball", "football", "basketball"]

sports.each do |sport|
  sp = Sport.find_or_create_by(name: sport)
  puts "Seeding players for #{sp.name}..."

  data = HTTParty.get("http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=#{sport}&response_format=JSON")
  data.dig("body", "players").map do |player|
    begin
      Player.create!(
        sport_id: sp.id,
        first_name: player["firstname"],
        last_name: player["lastname"],
        age:  player["age"],
        position: player["position"]
      )
      puts "Added #{player["firstname"]} #{player["lastname"]}"
    rescue StandardError => e
      puts "Failed to add #{player["firstname"]} #{player["lastname"]} due to: #{e.message}"
    end
  end
end
