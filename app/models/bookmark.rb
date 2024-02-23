class Bookmark < ApplicationRecord
  belongs_to :user

  def bookmark_type
    type.underscore
  end
end
