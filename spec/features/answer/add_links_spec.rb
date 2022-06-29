require 'rails_helper'

feature 'User can add link to answer', '
  In order to provide additional info to answer
  User would like to be able to add links
' do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given!(:question) { create(:question, user: user) }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Answer text'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'Google', href: url
    end
  end
end
