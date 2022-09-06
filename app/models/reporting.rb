class Reporting < ApplicationRecord
	belongs_to :user
	belongs_to :reported_user, class_name: "User", foreign_key: :reported_user_id
end
