class Users::OauthEmailConfirmationsController < ApplicationController
  before_action :find_or_create_user, only: :create

  def new
  end

  def create
    user = find_or_create_user

    if user&.persisted?
      if user.confirmed?
        redirect_to root_path, notice: 'Successfully authenticated.'
        nil
      else
        user.send_confirmation_instructions
        redirect_to new_user_session_path, alert: 'Check your email to confirm registration!'
      end
    else
      flash.now[:alert] = 'Please, enter valid email'
      render :new
    end
  end

  private

  def find_or_create_user
    generated_password = Devise.friendly_token[0, 20]

    User.first_or_create do |user|
      user.email = params_email[:email]
      user.password = generated_password
      user.password_confirmation = generated_password
      user.skip_confirmation_notification!
    end
  end

  def params_email
    params.permit(:email)
  end
end
