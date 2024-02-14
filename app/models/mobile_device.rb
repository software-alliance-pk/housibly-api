class MobileDevice < ApplicationRecord
	belongs_to :user
	validates_presence_of :mobile_device_token
end
