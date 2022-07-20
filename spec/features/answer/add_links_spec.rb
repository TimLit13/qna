require 'rails_helper'

feature 'User can add link to answer', '
  In order to provide additional info to answer
  User would like to be able to add links
' do
  given(:user) { create(:user) }
  given(:link_google) { create(:link, :google, linkable: question) }
  given(:link_github) { create(:link, :github, linkable: question) }
  given!(:question) { create(:question, user: user) }

  describe 'ability to add and delete links' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User should have ability to add another link', js: true do
      expect(page).to have_link 'add link'

      click_on 'add link'

      expect(page).to have_selector('.nested-fields', count: 2)
    end

    scenario 'User should have ability to delete link', js: true do
      expect(page).to have_link 'remove link'

      click_on 'remove link'

      expect(page).to_not have_selector('.nested-fields')
    end
  end

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'Answer text'

      fill_in 'Name', with: link_google.name
      fill_in 'Url', with: link_google.url

      click_on 'Create answer'
    end

    expect(page).to have_link link_google.name, href: link_google.url
  end

  scenario 'User adds two links when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'Answer text'

      fill_in 'Name', match: :first, with: link_google.name
      fill_in 'Url', match: :first, with: link_google.url

      click_on 'add link'

      page.all(:fillable_field, 'Name').last.set(link_github.name)
      page.all(:fillable_field, 'Url').last.set(link_github.url)

      click_on 'Create answer'
    end

    expect(page).to have_link link_google.name, href: link_google.url
    expect(page).to have_link link_github.name, href: link_github.url
  end
end
