# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title { Faker::Lorem.words.join(" ").titleize }
    description { Faker::Lorem.sentence }
  end
end
