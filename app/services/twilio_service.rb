class TwilioService
  def self.send_message(contact_no, sender_number, message_body)
    require 'twilio-ruby'
    client = Twilio::REST::Client.new(
      Rails.application.credentials.twilio[:account_sid],
      Rails.application.credentials.twilio[:auth_token]
    )
    client.messages.create(body: message_body, to: contact_no, from: sender_number)
    OpenStruct.new(success: true)
  rescue StandardError => e
    OpenStruct.new(success: false)
  end
end
