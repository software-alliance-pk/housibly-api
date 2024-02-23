class UserBookmark < Bookmark
  belongs_to :user
  belongs_to :bookmarked_user, class_name: 'User', foreign_key: :bookmarked_user_id

  validates_presence_of :bookmarked_user_id
end
