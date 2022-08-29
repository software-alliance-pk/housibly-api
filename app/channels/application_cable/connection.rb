module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      @jwt_token = request.params[:token] || raise(CustomErrorClass)
      self.current_user = find_verified_user
    end

    private
    attr_reader :jwt_token

    def find_verified_user
      payload = decode_token
      User.find_by_email(payload["email"])
    end


    def decode_token
      JsonWebTokenService.decode(jwt_token.to_s)
    end
  end
end
