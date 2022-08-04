class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index show]
  before_action :find_answer, only: %i[show]
  protect_from_forgery with: :null_session

  def index
    # authorize Answer

    render json: @question.answers
  end

  def show
    # authorize @answer

    render json: @answer
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
