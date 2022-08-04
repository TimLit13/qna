class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index show create update]
  before_action :find_answer, only: %i[show update destroy]
  protect_from_forgery with: :null_session

  def index
    # authorize Answer

    render json: @question.answers
  end

  def show
    # authorize @answer

    render json: @answer
  end

  def create
    answer = @question.answers.new(answer_params)
    # authorize answer
    answer.user_id = current_resource_owner.id

    if answer.save
      render json: answer
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # authorize @answer
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # authorize @answer
    if @answer.destroy
      render json: { messages: ['Answer deleted'] }
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
