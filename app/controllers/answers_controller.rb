class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted.'
    else
      redirect_to question_path(@answer.question), notice: 'Answer was not deleted.'
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
