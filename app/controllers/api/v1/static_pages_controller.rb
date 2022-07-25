class Api::V1::StaticPagesController < Api::V1::ApiController

  def static_page
    @page = Page.find_by(permalink:params[:permalink])
    if @page
      @page
    else
      render json: { message: 'Page not found' }
    end
  end
end