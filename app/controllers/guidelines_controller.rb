class GuidelinesController < ApplicationController
  def index
    @paper_trail =  PaperTrail::Version.limit(3).order(created_at: :desc)
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
  end

  def create
  end

  def guidelines
    @paper_trail =  PaperTrail::Version.limit(3).order(created_at: :desc)
    @page = Page.find_by(permalink: params[:permalink])
    render 'index'
  end

  def update

  end


  def job_lists
  end
end