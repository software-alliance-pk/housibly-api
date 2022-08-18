class Api::V1::BookmarksController <  Api::V1::ApiController
  def create
		@property = Property.find_by(id: params[:bookmark][:property_id])
		@bookmark = Bookmark.new(bookmark_params)
		@bookmark.property_id = @property.id
		@bookmark.user_id = @current_user.id
		if @bookmark.save
		  render json: {message: @bookmark}
		else
		  render_error_messages(@property)
		end
  end

  def get_current_user_bookmark
  	@bookmarks =  @current_user.bookmarks
  end

  

  def index
  	if params[:keyword].present?
  		@bookmarks =  @current_user.bookmarks if params[:keyword].downcase == "all"
  		@bookmarks =  @current_user.bookmarks.where("bookmark_type = (?)","property_bookmark") if params[:keyword].downcase == "property"
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
		  render json: {message: 'bookmark deleted successfully.'}, status: :ok
		end
  end 

  private
   def bookmark_params
	 params.require(:bookmark).permit(:bookmark_type)
   end
end