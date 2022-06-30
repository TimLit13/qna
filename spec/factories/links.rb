FactoryBot.define do
  factory :link do
    name { 'MyText' }
    url { 'MyText' }
    linkable_type { 'question' }

    trait :google do
      name { 'Google' }
      url { 'https://google.com' }
    end

    trait :github do
      name { 'Github' }
      url { 'https://github.com' }
    end
  end
end
