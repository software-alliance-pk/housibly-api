class TwilioService
  def self.send_message(contact_no, sender_number, message_body)
    require 'twilio-ruby'
    client = Twilio::REST::Client.new("AC81e89cf6e91eb32d34fb5c700ff5fbe0",'5c34923aa392ca780de363a89d83f064')
    client.messages.create(body: message_body,to: contact_no,from: sender_number)
    OpenStruct.new(success: true)
  rescue StandardError => e
    OpenStruct.new(success: false)
  end
end
