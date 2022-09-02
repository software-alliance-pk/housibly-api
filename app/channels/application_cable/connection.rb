module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      begin
      @jwt_token = request.params[:token]
      puts "<<<<<<<<<<<<current_user<<<<<<<<<<<<<<"
      self.current_user = find_verified_user
      rescue
        puts "connection is not created"
      end
    end

    private
    attr_reader :jwt_token
    def find_verified_user
      payload = decode_token
      puts "<<<<<<<<<payload<<<<<<<<<<<<"
      User.find_by_email(payload["email"])
    end
    def decode_token
      puts "<<<<<<jwt_token<<<<<<<<<<<"
      JsonWebTokenService.decode(jwt_token.to_s)
    end
  end
end
