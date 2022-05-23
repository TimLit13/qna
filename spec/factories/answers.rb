FactoryBot.define do
  factory :answer do
    body { 'MyAnswerText' }

    trait :invalid do
      body { nil }
    end
  end
end
