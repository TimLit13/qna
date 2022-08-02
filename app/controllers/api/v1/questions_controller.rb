class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show]

  def index
    @questions = Question.all
    # render json: @questions.to_json(include: [:answers])
    render json: @questions # , serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
