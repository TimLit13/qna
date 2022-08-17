require 'rails_helper'

RSpec.describe NewAnswerForQuestionJob, type: :job do
  # let(:service) { DailyDigest.new }
  let(:service) { double('NewAnswerNotification') }
  let(:answer) { double('Answer') }

  before do
    allow(NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerNotificationt#send_question_with_new_answer' do
    expect(service).to receive(:send_question_with_new_answer).with(answer)

    NewAnswerForQuestionJob.perform_now(answer)
  end
end
