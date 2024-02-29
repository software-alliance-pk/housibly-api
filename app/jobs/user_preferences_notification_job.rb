class UserPreferencesNotificationJob < ApplicationJob
  queue_as :default

  def perform(all_users: false, user_id: nil, preference_type: 'user_preference')
    if all_users
      User.where.not(profile_type: :support_closer).each do |user|
        notify_for_user_preference(user)
        notify_for_dream_addresses(user)
      end
    elsif user_id.present?
      user = User.find_by_id(user_id)
      return unless user

      preference_type == 'dream_address' ? notify_for_dream_addresses(user) : notify_for_user_preference(user)
    end
  end

  def notify_for_user_preference(user)
    return if user.user_preference.blank?

    page_info = {
      page: 1,
      per_page: 20
    }
    seller_ids = []
    notifications_sent = 0

    loop do
      properties = PropertiesSearchService.search_by_preference(user.user_preference.attributes, page_info, user.id)
      puts "ppppppppppppppppppppppppp #{properties.length} "

      notifications_sent = send_notifications(properties, seller_ids, notifications_sent)

      break if notifications_sent == 4 || properties.length < page_info[:per_page]
      page_info[:page] += 1
    end
  end

  def notify_for_dream_addresses(user)
    seller_ids = []
    notifications_sent = 0

    user.dream_addresses.each do |dream_address|
      properties = PropertiesSearchService.search_in_circle(dream_address.slice(:latitude, :longitude), 5, nil, user.id)
      notifications_sent = send_notifications(properties, seller_ids, notifications_sent)
      break if notifications_sent == 4
    end
  end

  private

    def send_notifications(properties, seller_ids, notifications_sent)
      properties.each do |property|
        break if notifications_sent == 4
        next if UserNotification.exists?(property_id: property.id, recipient_id: user.id)
        notifications_sent += 1

        # For BUYER
        UserNotification.create(
          actor_id: property.user_id, recipient_id: user.id, property_id: property.id,
          action: "#{property.user.full_name} is selling properties that you might like",
          title: property.title, event_type: "buy_property"
        )

        # For SELLER
        next if seller_ids.include?(property.user_id)
        seller_ids << property.user_id
        UserNotification.create(
          actor_id: user.id, recipient_id: property.user_id, property_id: property.id,
          action: "#{user.full_name} wants to search for a house that you are selling",
          title: user.full_name, event_type: "sell_property"
        )
      end

      notifications_sent
    end

end
