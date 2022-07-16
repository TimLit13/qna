require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    stub_connection user_id: user.id
  end

  it 'subscribes' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).not_to have_streams
    perform :follow
    expect(subscription).to have_stream_from('questions')
  end
end
