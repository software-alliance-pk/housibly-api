class Visitor < ApplicationRecord
	belongs_to :user
	belongs_to :visitor , class_name: "User", foreign_key: :visit_id
end 
