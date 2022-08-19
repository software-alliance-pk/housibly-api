class Api::V1::BookmarksController < Api::V1::ApiController
  def create
    type = bookmark_params[:bookmark_type]
    @property = Property.find_by(id: params[:id]) if type == "property_bookmark"
    property_id = params[:id] if @property
    @user = User.find_by(id: params[:id]) if type == "user_bookmark"
    user_id = params[:id] if @user
    unless Bookmark.check_property_already_booked(@property).present? || Bookmark.check_user_already_booked(@user).present?
      @bookmark = bookmark_params[:bookmark_type].titleize.gsub(" ", "").constantize.new
      property_id ? @bookmark.property_id = property_id : @bookmark.user_id = user_id
      if @bookmark.save
        @bookmark
      else
        render_error_messages(@bookmark)
      end
    else
      render json: { message: "Property is already bookmarked" }, status: :unprocessable_entity
    end
  end

  def get_current_user_bookmark
    @bookmark_properties = @current_user.properties.where(is_bookmark: true)
  end

  def filter_bookmarks
    if params[:keyword].present?
      @bookmarks = @current_user.bookmarks if params[:keyword].downcase == "all"
      @bookmarks = @current_user.bookmarks.where("bookmark_type = (?)", "property_bookmark") if params[:keyword].downcase == "property"
      @bookmarks = @current_user.bookmarks.where("bookmark_type = (?)", "user_bookmark") if params[:keyword] == "support_closers"
      if @bookmarks
        @bookmarks
      else
        render_error_messages(@bookmarks)
      end
    end
  end

  def destroy
    @bookmark = Bookmark.find_by(id: params[:id])
    if @bookmark.destroy
      render json: { message: 'bookmark deleted successfully.' }, status: :ok
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:bookmark_type)
  end
end