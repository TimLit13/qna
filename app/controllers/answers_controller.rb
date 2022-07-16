class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: %i[create publish_answer]
  before_action :find_answer, only: %i[update destroy mark_answer_as_best]

  after_action :publish_answer, only: :create

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

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question/#{@question.id}/answers",
      hash_for_broadcast
    )
    # ActionCable.server.broadcast(
    #   "question/#{@question.id}/answers", {
    #     render template: "answers/create",
    #       assigns: { answer: @answer },
    #       locals: { current_user: current_user }
    #   }
    # )
  end

  def hash_for_broadcast
    created_hash = {
      answer: @answer,
      rating: @answer.total_rating,
      links: @answer.links,
      question_author: @question.user,
      files: []
    }
    add_file_to_hash(created_hash) if @answer.files.attached?
    created_hash
  end

  def add_file_to_hash(created_hash)
    @answer.files.each_with_index do |file, index|
      created_hash[:files][index] = {
        id: file.id,
        name: file.filename.to_s,
        url: url_for(file)
      }
    end
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy])
  end
end
