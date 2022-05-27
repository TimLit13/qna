FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '11111111' }
    password_confirmation { '11111111' }
  end
end
