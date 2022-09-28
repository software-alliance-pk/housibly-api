class UserPreference < ApplicationRecord
  belongs_to :user
  cattr_accessor :weight_age
end
