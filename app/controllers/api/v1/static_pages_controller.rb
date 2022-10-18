class Api::V1::StaticPagesController < Api::V1::ApiController
  skip_before_action :authenticate_user

  def static_page
    @page = Page.find_by(permalink:params[:permalink])
    if @page
      @page
    else
      render json: { message: 'Page not found' }
    end
  end
end