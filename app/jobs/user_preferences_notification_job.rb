class UserPreferencesNotificationJob < ApplicationJob
  queue_as :default
  def self.perform_now(user_id)
    if user_id.present?
      user = User.find_by_id(user_id)
      page_info = {
        page: 1,
        per_page: 20
      }
      if user.user_preference.present?
        loop do
          properties = PropertiesSearchService.search_by_preference(user.user_preference.attributes, page_info, user.id)
          properties.each do |property|
            UserNotification.create(
              actor_id: property.user_id, recipient_id: user_id,
              action: "#{property.user.full_name} is selling properties that you might like",
              title: "Matching Property", event_type: "property_match"
            )
          end
          break if properties.count < page_info[:per_page]
          page_info[:page] += 1
        end
      end

    end
  end

end
