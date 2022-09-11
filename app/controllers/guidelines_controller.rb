class GuidelinesController < ApplicationController
  before_action :get_paper_trail
  before_action :get_page, only: [:index, :create, :guidelines]
  def index
  end

  def create
    @page.update(content: params[:content])
    render 'index'
  end

  def guidelines

    render 'index'
  end

  def get_page
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
  end

  def get_paper_trail
    @paper_trail =  PaperTrail::Version.order(created_at: :desc).limit(3)
  end


  def job_lists
  end
end