require 'rails_helper'

feature 'User can add link to question', '
  In order to provide additional info to question
  User would like to be able to add links
' do
  given(:user) { create(:user) }
  given(:link_google) { { name: 'Google', url: 'https://google.com' } }
  given(:link_github) { { name: 'Github', url: 'https://github.com' } }

  describe 'ability to add and delete links' do
    background do
      sign_in(user)
      visit new_question_path
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

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: link_google[:name]
    fill_in 'Url', with: link_google[:url]

    click_on 'Ask'

    within '.question' do
      expect(page).to have_link link_google[:name], href: link_google[:url]
    end
  end

  scenario 'User adds two links when asks a question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: link_google[:name]
    fill_in 'Url', with: link_google[:url]

    click_on 'add link'

    page.all(:fillable_field, 'Name').last.set(link_github[:name])
    page.all(:fillable_field, 'Url').last.set(link_github[:url])

    click_on 'Ask'

    within '.question' do
      expect(page).to have_link link_google[:name], href: link_google[:url]
      expect(page).to have_link link_github[:name], href: link_github[:url]
    end
  end
end
