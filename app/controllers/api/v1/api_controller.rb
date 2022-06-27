class Api::V1::ApiController < ApiController
  include AuthenticateHelper
  before_action :authenticate_user

end