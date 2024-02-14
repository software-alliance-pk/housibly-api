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
                },
                contentAvailable: true,
                priority: 'high'
    }
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

  def self.fcm_push_notification_for_user_preference_address(recipient,actor,user_notification)
    data = {
      id: user_notification.id,
      action: user_notification.action,
      title: user_notification.property.title,
      type: user_notification.event_type,
      event_const: user_notification.type,
      recipient: recipient,
      property_id: user_notification.property_id,
      property_owner: actor,
      avatar: actor&.avatar&.url,
      property_image: user_notification.property.images.first.url rescue ""
    }
    fcm_client = FCM.new(ENV['FCM_SERVER_KEY'])
    options = {
      data: data,
      notification: {
        property_id: property.id,
        id: user_notification.id,
        title: user_notification.title,
        type: user_notification.event_type,
        property_images: user_notification.property_image,
        body: user_notification.action,
        sound: 'default'
      },
      contentAvailable: true,
      priority: 'high'
    }
    puts "Notification content: #{options}"

    registration_ids = user_notification.recipient.mobile_devices.pluck(:mobile_device_token)
    registration_ids.each do |registration_id|
      response = fcm_client.send(registration_id, options)
      puts "responseeeeeeeeeee on BUYER side"
      puts response
    end
  end

  def self.fcm_push_notification_for_user_address_search(recipient,actor,user_notification)
    data = {
      property_id: property.id,
      id: user_notification.id,
      action: user_notification.action,
      title: user_notification.title,
      type: user_notification.event_type,
      event_const: user_notification.type,
      recipient: recipient,
      property_owner: actor,
      avatar: actor&.avatar&.url,
      property_images: user_notification.property_image
    }
    fcm_client = FCM.new(ENV['FCM_SERVER_KEY'])
    options = {
      data: data,
      notification: {
        property_id: property.id,
        id: user_notification.id,
        title: user_notification.title,
        type: user_notification.event_type,
        body: user_notification.action,
        property_images: user_notification.property_image,
        sound: 'default'
      },
      contentAvailable: true,
      priority: 'high'
    }
    puts "Notification content: #{options}"

    registration_ids = user_notification.recipient.mobile_devices.pluck(:mobile_device_token)
    registration_ids.each do |registration_id|
      response = fcm_client.send(registration_id, options)
      puts "responseeeeeeeeeeeeeeeeeeeee on SELLER side"
      puts response
    end
  end

end
