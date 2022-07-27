class TwilioService
  def self.send_message(contact_no, sender_number, message_body)
    require 'twilio-ruby'
    account_sid = Rails.application.credentials.twilio[:account_sid] if Rails.env.development?
    account_sid = ENV['TWILLIO_SID'] if Rails.env.production?
    auth_token = Rails.application.credentials.twilio[:auth_token] if Rails.env.development?
    auth_token = ENV["TWILLIO_AUTH_TOKEN"] if Rails.env.production?

    client = Twilio::REST::Client.new(account_sid, auth_token)
    client.messages.create(body: "Your Housibly OTP code is: " + message_body, to: contact_no, from: sender_number)
    OpenStruct.new(success: true)
  rescue StandardError => e
    OpenStruct.new(success: false)
  end
end
