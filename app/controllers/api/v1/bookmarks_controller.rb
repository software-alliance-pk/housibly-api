# frozen_string_literal: true

class Api::V1::BookmarksController < Api::V1::ApiController
  before_action :validate_bookmark_type, only: [:create]

  def index
    @bookmarks = case params[:bookmark_type]
      when 'user_bookmark'
        @current_user.user_bookmarks
      when 'property_bookmark'
        @current_user.property_bookmarks
      else
        @current_user.bookmarks
      end
  end

  def create
    @bookmark = bookmark_params[:bookmark_type].titleize.gsub(' ', '').constantize.new(user_id: @current_user.id)

    if bookmark_params[:bookmark_type] == 'user_bookmark'
      return render json: { message: 'You cannot bookmark yourself!' }, status: 422 if @current_user.id == bookmark_params[:bookmarked_user_id].to_i
      return render json: { message: 'Already bookmarked' } if @current_user.user_bookmarks.exists?(bookmarked_user_id: bookmark_params[:bookmarked_user_id])
      @bookmark.bookmarked_user_id = bookmark_params[:bookmarked_user_id]
    else
      return render json: { message: 'Already bookmarked' } if @current_user.property_bookmarks.exists?(property_id: bookmark_params[:property_id])
      @bookmark.property_id = bookmark_params[:property_id]
    end

    unless @bookmark.save
      render_error_messages(@bookmark)
    end
  end

  def destroy
    bookmark = Bookmark.find_by(id: params[:id])
    return render json: { message: "Bookmark not found" }, status: :not_found unless bookmark.present?

    if bookmark.destroy
      render json: { message: 'Bookmark deleted successfully.' }
    else
      render_error_messages(bookmark)
    end
  end

  private

    def bookmark_params
      params.require(:bookmark).permit(:bookmark_type, :property_id, :bookmarked_user_id)
    end

    def validate_bookmark_type
      return if bookmark_params[:bookmark_type].in? ['property_bookmark', 'user_bookmark']
      render json: { message: 'Bookmark type should be one of the following: property_bookmark, user_bookmark' }, status: 422
    end
end
