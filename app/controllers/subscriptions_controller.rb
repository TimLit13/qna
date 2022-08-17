class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create

  after_action :verify_authorized

  def create
    @subscription = @question.subscriptions.new(user: current_user)
    authorize @subscription
    @subscription.save!
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    authorize @subscription
    @subscription.destroy!
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
