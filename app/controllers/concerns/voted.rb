module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[rate_up rate_down cancel_rate]
  end

  def rate_up
    authorize @votable
    if current_user.author_of?(@votable)
      add_message_into_errors
      render_json_with_errors
    else
      @votable.rate_up(current_user)

      render_json_with_rating
    end
  end

  def rate_down
    authorize @votable
    if current_user.author_of?(@votable)
      add_message_into_errors
      render_json_with_errors
    else
      @votable.rate_down(current_user)

      render_json_with_rating
    end
  end

  def cancel_rate
    authorize @votable
    if current_user.author_of?(@votable)
      add_message_into_errors
      render_json_with_errors
    else
      @votable.cancel_rate(current_user)

      render_json_with_rating
    end
  end

  private

  def add_message_into_errors
    @votable.errors.add(model_klass.name, 'can not be rated because you are author')
  end

  def render_json_with_rating
    render json: {
      resource_id: @votable.id,
      resource_name: controller_name,
      rating: @votable.total_rating,
      rated_before: @votable&.rated_before?(current_user).to_s,
      status: :accepted
    }
  end

  def render_json_with_errors
    render json: {
      error: @votable.errors.full_messages,
      status: :unprocessable_entity
    }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end
