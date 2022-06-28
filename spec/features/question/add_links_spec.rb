require 'rails_helper'

feature 'User can add link to question', '
  In order to provide additional info to question
  User would like to be able to add links
' do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'Google', href: url
  end
end
