FactoryBot.define do
  factory :answer do
    body { 'MyAnswerText' }

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after :create do |answer|
        answer.files.attach({ io: File.open("#{Rails.root}/README.md"), filename: 'README1.md' })
        answer.files.attach({ io: File.open("#{Rails.root}/README.md"), filename: 'README2.md' })
      end
    end
  end
end
