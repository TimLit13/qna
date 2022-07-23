class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with_oauth2('Github')
  end

  def vkontakte
    sign_in_with_oauth2('Vkontakte')
  end

  def yandex
    sign_in_with_oauth2('Yandex')
  end

  private

  def sign_in_with_oauth2(provider_name)
    # render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
