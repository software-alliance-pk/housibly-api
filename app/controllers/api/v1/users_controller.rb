class Api::V1::UsersController < Api::V1::ApiController
  def get_profile
    @current_user
  end
end