json.extract! user_setting, :push_notification, :inapp_notification, :email_notification, :vibration, :payment_method if user_setting.present?
