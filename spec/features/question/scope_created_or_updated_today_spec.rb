require 'rails_helper'

feature 'User can mark answer as best', '
  In order to determine best answer
  User would like to be able to mark answer as best
' do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 3, user: user) }

  describe 'scopes' do
    describe '#created_or_updated_today' do
      background do
        questions.last.update(created_at: DateTime.now-2, updated_at: DateTime.now-2)
      end

      scenario 'returns only created or updated today ' do
        expect(Question.created_or_updated_today.count).to eq(2)
        expect(Question.created_or_updated_today.first).to be_an_instance_of(Question) 
      end
    end
  end
end
