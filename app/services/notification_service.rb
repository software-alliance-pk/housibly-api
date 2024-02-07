class NotificationService
  require 'fcm'
  def self.fcm_push_notification_for_chat_messages(recipient,actor,user_notification)
    puts "<<<<<<<<<<<<<PUSH NOTIFICATIONS<<<<<<<<<<<<<<<<"
    data = {
            id: user_notification.id,
            action: user_notification.action,
            title: user_notification.title,
            type: user_notification.event_type,
            event_const: user_notification.type,
            recipient: recipient,
            sender:actor,
            avatar: actor&.avatar&.url,
            conversation_id: user_notification.conversation_id
          }
    fcm_client = FCM.new(ENV['FCM_SERVER_KEY'])
    options = { data: data,
                notification: {
                  id: user_notification.id,
                  title: user_notification.title,
                  type: user_notification.event_type,
                  body: user_notification.action,
                  sound: 'default'
                }
    }
    puts "Sending notification to #{recipient.full_name}..."
    puts "Notification content: #{options}"

    registration_ids = user_notification.recipient.mobile_devices.pluck(:mobile_device_token)
    registration_ids.each do |registration_id|
      response = fcm_client.send(registration_id, options)
      puts "responseeeeeeeeeeeeeeeeeeeee"
      puts response
    end
  end

  def self.fcm_push_notification_for_complete_profile(recipient,actor,user_notification)
    data = {
            action: user_notification.action,
            type: user_notification.type,
            event_const: user_notification.type
           }
    fcm_client = FCM.new(ENV['FCM_SERVER_KEY'])
    options = { data: data,
                notification: {
                  body: user_notification.action,
                  sound: 'default'
                }
    }

    registration_ids = user_notification.recipient.mobile_devices.pluck(:mobile_device_token)
    registration_ids.each do |registration_id|
      response = fcm_client.send(registration_id, options)
      puts response
    end
  end

end
