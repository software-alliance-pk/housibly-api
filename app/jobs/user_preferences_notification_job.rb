class UserPreferencesNotificationJob < ApplicationJob
  queue_as :default
  def perform(user_id)
    if user_id.present?
      user = User.find_by_id(user_id)
      page_info = {
        page: 1,
        per_page: 20
      }
      if user.user_preference.present?
        seller_ids = []
        loop do
          properties = PropertiesSearchService.search_by_preference(user.user_preference.attributes, page_info, user.id)
          properties.each do |property|
            property_images = property.images.map(&:url)
            property_image = property_images.join(', ')
            # For BUYER
            UserNotification.create(
              actor_id: property.user_id, recipient_id: user_id, 
              property_id: property.id, property_image: property_image,
              action: "#{property.user.full_name} is selling properties that you might like",
              title: property.title, event_type: "buy_property"
            )
            # For SELLER
            next if seller_ids.include?(property.user_id)
            seller_ids << property.user_id
            UserNotification.create(
              actor_id: user_id, recipient_id: property.user_id,
              property_id: property.id, property_image: property_image,
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
end
