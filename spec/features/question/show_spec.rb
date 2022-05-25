require 'rails_helper'

feature 'User can see question and answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Can see list of answers' do
    visit question_path(question)
    expect(page).to have_content('MyAnswerText', count: 3)
  end
end
