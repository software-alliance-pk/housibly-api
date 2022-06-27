class Api::V1::ApiController < ActionController::API
  include AuthenticateHelper
  before_action :authenticate_user

  def not_found
    render json: { error: 'not_found' }
  end

end