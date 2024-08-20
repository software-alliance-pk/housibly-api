class GuidelinesController < ApplicationController
  before_action :get_paper_trail, only: [:index,:create,:guidelines]
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

  def contact_us
    file_path = Rails.root.join('public', 'contact_us.html')
    send_file file_path, type: 'text/html', disposition: 'inline'
  end 
  def privacy_policy
    file_path = Rails.root.join('public', 'privacy_policy.html')
    send_file file_path, type: 'text/html', disposition: 'inline'
  end

  def get_page
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
  end

  def get_paper_trail
    @paper_trail =  PaperTrail::Version.where(item_type: "Page").order(created_at: :desc).limit(3)
  end

  def job_list
    @paper_trail = PaperTrail::Version.where(item_type: "JobList").order(created_at: :desc).limit(3)
    @job_list = JobList.new(title: params[:title])
    if @job_list.save
      redirect_to job_lists_guidelines_path()
    else
     redirect_to job_lists_guidelines_path
    end
  end 

  def job_lists
    @paper_trail = PaperTrail::Version.where(item_type: "JobList").order(created_at: :desc).limit(3)
    @job_lists = JobList.all.order(created_at: :desc)
  end
  def delete_job_list
    @job_list = JobList.find_by(id: params[:id])
    if @job_list.present?
      if @job_list.destroy
        redirect_to job_lists_guidelines_path
      end
    end
  end

end