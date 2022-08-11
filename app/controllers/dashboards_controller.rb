class DashboardsController < ApplicationController
  def index
    unless params[:search].blank?
      @new_users = User.new_users.paginate(page: params[:page], per_page: 1)
      @new_users = new_user.custom_search(params[:search]).paginate(page: params[:page], per_page: 1)
    else
      @new_users = User.new_users.paginate(page: params[:page], per_page: 1)
    end
    
  end
end