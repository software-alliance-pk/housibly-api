class PreferenceProperty < ApplicationRecord
  belongs_to :user_preference
  belongs_to :property
end
