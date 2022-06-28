FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      after :create do |question|
        question.files.attach({ io: File.open("#{Rails.root}/README.md"), filename: 'README1.md' })
        question.files.attach({ io: File.open("#{Rails.root}/README.md"), filename: 'README2.md' })
      end
    end
  end
end
