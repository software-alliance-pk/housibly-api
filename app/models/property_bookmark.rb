class PropertyBookmark < Bookmark
  belongs_to :user
  belongs_to :property

  validates_presence_of :property_id
end
