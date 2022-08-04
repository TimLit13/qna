class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index]
  before_action :find_answer, only: %i[]
  protect_from_forgery with: :null_session

  def index
    # authorize Answer

    render json: @question.answers
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end
