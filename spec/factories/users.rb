# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { "my_test_password&^" }
  end

  factory :owner, :parent => :user
end
