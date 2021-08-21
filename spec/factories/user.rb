FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{Faker::Internet.email}#{n}" }
    password_digest { Faker::Alphanumeric.alpha(number: 10) }
  end
end

