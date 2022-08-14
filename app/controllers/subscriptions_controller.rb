class SubscriptionsController < ApplicationController
  before_action :find_question

  def create
    @subscription = @question.subscriptions.new(user: current_user)
    authorize @subscription
    @subscription.save!
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
