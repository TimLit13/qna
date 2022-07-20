require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  before do
    stub_connection user_id: user.id
  end

  it 'subscribes without streams' do
    subscribe(question_id: nil)

    expect(subscription).to be_confirmed
    expect(subscription).not_to have_stream_from("question/#{question.id}/comments")
  end

  it 'subscribes with streams' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("question/#{question.id}/comments")
  end
end
