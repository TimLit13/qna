FactoryBot.define do
  factory :award do
    title { 'My award' }
    after :create do |award|
      award.image.attach({ io: "#{Rails.root}/spec/support/ruby.jpeg", filename: 'award.jpeg' })
    end
  end
end
