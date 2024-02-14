class UserPreferencesNotificationJob < ApplicationJob
  queue_as :default
  def perform(all_users: false, user_id: nil)
    if all_users
      User.where.not(profile_type: :support_closer).each do |user|
        notify(user)
      end
    else
      if user_id.present?
        user = User.find_by_id(user_id)
        notify(user)
      end
    end
  end

  def notify(user)
    page_info = {
      page: 1,
      per_page: 20
    }
    if user.user_preference.present?
      seller_ids = []
      loop do
        properties = PropertiesSearchService.search_by_preference(user.user_preference.attributes, page_info, user.id)
        properties.each do |property|
          next if UserNotification.find_by(property_id: property.id, recipient_id: user.id)
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
            action: "#{user.full_name} wants to search for a house in areas that you are offering",
            title: property.title, event_type: "sell_property"
          )
        end
        break if properties.count < page_info[:per_page]
        page_info[:page] += 1
      end
    end
  end
end
