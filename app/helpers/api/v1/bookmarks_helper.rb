module Api::V1::BookmarksHelper
	def check_user_bookmark_id(id)
		_bookmark = @current_user.bookmarks.find_by(property_id: id)
		_bookmark.id
	end
end
