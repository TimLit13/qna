require 'rails_helper'

feature 'Anybody can view list of questions' do
  given(:user) { create(:user) }
  given!(:list_of_questions) { create_list(:question, 3, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'Can view questions' do
      visit questions_path
      expect(page).to have_content('MyText', count: 3)
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Can view questions' do
      visit questions_path
      expect(page).to have_content('MyText', count: 3)
    end
  end
end
