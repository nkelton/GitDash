FactoryBot.define do
  factory :profile do
    association :user, factory: :user
    metadata { {} }
  end
end
