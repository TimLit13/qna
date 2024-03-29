class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  before_action :find_subscription, only: %i[show update]
  before_action :pass_question_to_client, only: :show

  # before_action :authorize_question!

  after_action :publish_question, only: %i[create]

  after_action :verify_authorized

  def index
    authorize Question
    @questions = Question.all
  end

  def show
    authorize @question
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = Question.new
    authorize @question
    @question.links.new # build_links
    @question.build_award # new
  end

  def edit
    authorize @question
  end

  def create
    @question = Question.new(question_params)
    authorize @question
    @question.user = current_user
    notice = 'Your question successfully created'
    notice = @question.award.present? ? "#{notice} with award" : notice
    if @question.save
      redirect_to @question, notice: notice
    else
      render :new
    end
  end

  def update
    authorize @question
    @question.update(question_params)
  end

  def destroy
    authorize @question
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted'
    else
      redirect_to question_path(@question), notice: 'Question was not deleted'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[name url],
                                     award_attributes: %i[title image])
  end

  def pass_question_to_client
    gon.user_id = current_user&.id
    gon.question_id = @question.id
  end

  def find_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  # def authorize_question!
  #   authorize(@question || Question)
  # end
end
