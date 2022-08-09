class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    error_message = 'You are not authorized to perform this action.'
    respond_to do |format|
      format.html do
        flash[:alert] = error_message
        redirect_to(request.referer || root_path)
      end

      format.json { render json: { error: error_message }, status: :forbidden }
    end
  end
end
