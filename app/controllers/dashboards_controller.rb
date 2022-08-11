class DashboardsController < ApplicationController
  def index
    unless params[:search].blank?
      @new_users = User.new_users
      @new_users = new_user.custom_search(params[:search])
    else
      @new_users = User.new_users
    end
    
  end
end