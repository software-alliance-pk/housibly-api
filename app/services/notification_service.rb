class NotificationService
    require 'fcm'
    def self.fcm_push_notification_for_chat_messages(recipient,actor,type,user_notification,action)
        puts "<<<<<<<<<<<<<<#{actor}<<<<<<<<<<<<<<<<<<"
         puts "<<<<<<<<<<<<<<#{recipient}<<<<<<<<<<<<<<<<<<"
        puts "<<<<<<<<<<<<<<#{type}<<<<<<<<<<<<<<<<<<"
        # conversation = user_notification.message.conversation
        data = {action: user_notification.action,type: user_notification.type, event_const: type }
        fcm_client = FCM.new('AAAAyBDcdag:APA91bFtIo0jPppavG5gExCfcRJMsMvnzJTENiBscXdM6P86rOsrVgF1kH-rI9gSYkpcShtvpukhZlR8G9aK9pC7cTw8C0L_dFEMT4thE_KK0g7rPlz7JUCDO1AU3mF2778JnShuUMzs') # set your FCM_SERVER_KEY

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

    def self.fcm_push_notification_for_complete_profile(recipient,actor,type,user_notification,action)
        puts "<<<<<<<<<<<<<<#{actor}<<<<<<<<<<<<<<<<<<"
         puts "<<<<<<<<<<<<<<#{recipient}<<<<<<<<<<<<<<<<<<"
        puts "<<<<<<<<<<<<<<#{type}<<<<<<<<<<<<<<<<<<"
        # conversation = user_notification.message.conversation
        data = {action: user_notification.action,type: user_notification.type, event_const: type }
        fcm_client = FCM.new('AAAAyBDcdag:APA91bFtIo0jPppavG5gExCfcRJMsMvnzJTENiBscXdM6P86rOsrVgF1kH-rI9gSYkpcShtvpukhZlR8G9aK9pC7cTw8C0L_dFEMT4thE_KK0g7rPlz7JUCDO1AU3mF2778JnShuUMzs') # set your FCM_SERVER_KEY

        options = { data: data,
                    notification: {
                      body: user_notification.action,
                      sound: 'default'
                    }
        }

        registration_ids = user_notification.recipient.mobile_devices.pluck(:mobile_device_token)
        registration_ids.each do |registration_id|
            debugger
         response = fcm_client.send(registration_id, options)
          puts response
      end
    end
end