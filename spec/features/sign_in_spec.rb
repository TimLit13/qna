require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  User would like to be able to sign in
} do
  scenario 'Registered user tries to sign in' do
    User.create!(email: 'user@test.com', password: '11111111')

    visit '/login'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '11111111'

    expect(page).to have_content 'Signed in successfully'
  end
  
  scenario 'Unregistered user tries to sign in'
end
