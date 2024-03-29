class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]
  protect_from_forgery with: :null_session

  def index
    @questions = Question.all
    # render json: @questions.to_json(include: [:answers])
    render json: @questions # , serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    question = current_resource_owner.questions.new(question_params)
    authorize question

    if question.save
      render json: question
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @question
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question
    if @question.destroy
      render json: { messages: ['Question deleted'] }
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
