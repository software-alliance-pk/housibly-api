class Api::V1::SavedSearchesController < Api::V1::ApiController
  before_action :set_saved_search, only: [:show, :update, :destroy]

  def index
    @saved_searches = @current_user.saved_searches.order(created_at: :desc)
  end

  def show; end # for getting a specific saved search

  def create
    @saved_search = @current_user.saved_searches.build(saved_search_params)
    if @saved_search.save
      render 'show'
    else
      render_error_messages(@saved_search)
    end
  end

  def update
    if @saved_search.update(saved_search_params)
      render 'show'
    else
      render_error_messages(@saved_search)
    end
  end

  def destroy
    if @saved_search.destroy
      render json: { message: 'Saved search has been deleted successfully!' }
    else
      render_error_messages(@saved_search)
    end
  end

  private

    def saved_search_params
      params.require(:saved_search).permit(:title, :search_type, :display_address, :zip_code, :radius, origin: [:lat, :lng], polygon: [:lat, :lng])
    end

    def set_saved_search
      @saved_search = SavedSearch.find_by(id: params[:id])
      render json: { message: "Saved search with id=#{params[:id]} not found" }, status: :not_found unless @saved_search
    end

    def page_info
      {
        page: params[:page],
        per_page: 10
      }
    end
end
