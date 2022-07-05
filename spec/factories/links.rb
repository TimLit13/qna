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

    trait :gist do
      name { 'Gist' }
      url { 'https://gist.github.com/463382278baa1715551a0392ce98341c' }
    end
  end
end
