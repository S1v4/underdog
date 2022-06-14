FactoryBot.define do
  factory :sport do
    name { "football" }

    trait :with_players do
      after(:create) do |sport, evaluator|
        create_list(:player, 10, sport: sport)
      end
    end

    trait :with_players_in_same_position do
      after(:create) do |sport, evaluator|
        create_list(:player, 10, sport: sport, position: Faker::Sports::Football.position)
      end
    end
  end
end
