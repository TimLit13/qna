class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy mark_answer_as_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.question.update(best_answer_id: nil) if @answer.question.best_answer_id
    @answer.destroy if @answer.user == current_user
  end

  def mark_answer_as_best
    @question = @answer.question
    @question.mark_best_answer(@answer) if @question.user == current_user

    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end
end
