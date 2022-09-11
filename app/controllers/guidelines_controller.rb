class GuidelinesController < ApplicationController
  def index
    @paper_trail =  PaperTrail::Version.order(created_at: :desc).last(3)
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
  end

  def create
    @paper_trail =  PaperTrail::Version.order(created_at: :desc).last(3)
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
    @page.update(content: params[:content])
    render 'index'
  end

  def guidelines
    @paper_trail =  PaperTrail::Version.order(created_at: :desc).last(3)
    @page = Page.find_by(permalink: params[:permalink])
    render 'index'
  end

  def update
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
    @page.update(content: params[:content])

  end


  def job_lists
  end
end