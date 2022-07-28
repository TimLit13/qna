class AwardsController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :find_awards, only: %i[index]

  skip_authorization_check

  def index
  end

  private

  def find_awards
    @awards = current_user.awards
  end
end
