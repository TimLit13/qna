class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    find_authorization
    return @authorization.user if @authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: DateTime.now)
      user.skip_confirmation_notification!
    end
    user.create_authorization(auth)

    user
  end

  private

  def find_authorization
    @authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
  end
end
