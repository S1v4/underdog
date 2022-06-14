FactoryBot.define do
  factory :player do
    sport_id { 1 }
    first_name { Faker::Name.first_name } 
    last_name { Faker::Name.last_name }
    age { Faker::Number.between(from: 25, to: 35) }
    position { Faker::Sports::Football.position }
  end
end
