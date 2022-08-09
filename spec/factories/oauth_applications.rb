FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'https://localhost:3000' }
    uid { '12345678' }
    secret { '87654321' }
  end
end
