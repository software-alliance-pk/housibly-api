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