class Bookmark < ApplicationRecord
  belongs_to :property,optional: true
  belongs_to :user , optional: true
  scope :check_property_already_booked, -> (id) {
    (where("type = (?)", "PropertyBookmark").where("property_id = (?)", id))
  }
  scope :check_user_already_booked, -> (id) {
    (where("type = (?)", "UserBookmark").where("user_id = (?)", id))
  }
end
