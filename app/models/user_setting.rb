class UserSetting < ApplicationRecord
	belongs_to :user
	validates_inclusion_of :payment_method, in: ['credit_card', 'apple_pay', 'google_wallet']
end
