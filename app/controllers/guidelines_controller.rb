class GuidelinesController < ApplicationController
  def index
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
  end

  def guidelines
    @page = Page.find_by(permalink: params[:permalink])
    render 'index'
  end

  def job_lists
  end
end