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

  def job_list
    @job_list = JobList.new(title: params[:title])
    if @job_list.save
      redirect_to job_lists_guidelines_path()
    else
     redirect_to job_lists_guidelines_path
    end
  end 

  def job_lists
    @job_lists = JobList.all.order(created_at: :desc)
  end
  def delete_job_list
    @job_list = JobList.find_by(id: params[:id])
    if @job_list.present?
      if @job_list.destroy
        render json: {message: "successfully deleted"},status: :ok
      end
    end
  end

end