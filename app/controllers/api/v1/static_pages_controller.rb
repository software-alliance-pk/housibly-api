class Api::V1::StaticPagesController < Api::V1::ApiController

  def static_page
    @page = Page.find_by(permalink:params[:permalink])
  end
end