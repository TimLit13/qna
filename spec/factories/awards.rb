FactoryBot.define do
  factory :award do
    title { 'My award' }
    after :create do |award|
      award.image.attach({ io: File.open("#{Rails.root}/spec/support/ruby.jpeg"), filename: 'award.jpeg', content_type: 'image/jpeg' })
    end
  end
end
