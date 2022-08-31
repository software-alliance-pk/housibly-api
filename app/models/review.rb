class Review < ApplicationRecord
    belongs_to :user
    belongs_to :support_closer, class_name: "User", foreign_key: :support_closer_id
end
