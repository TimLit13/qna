FactoryBot.define do
  factory :vote do
    rating { 1 }
    user { nil }
    votable { nil }
  end
end
