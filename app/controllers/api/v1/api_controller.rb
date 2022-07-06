class Api::V1::ApiController < ActionController::API
  include AuthenticateHelper
  before_action :authenticate_user

  def not_found
    render json: { error: 'not_found' }
  end

  def render_error_messages(object)
    render json: {
      error: object.errors.messages.map { |msg, desc|
        msg.to_s + ' ' + desc[0] }.join(', ')
    }, status: :unprocessable_entity
  end

end