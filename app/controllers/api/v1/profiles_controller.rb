class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def all
    user_profiles = User.where.not(id: current_resource_owner.id)

    render json: user_profiles # , serializer: UserSerializer
  end
end
