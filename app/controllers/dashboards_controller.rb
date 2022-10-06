class DashboardsController < ApplicationController
  def index
    @new_users = User.new_users.paginate(page: params[:page], per_page: 3)
    @new_users = User.all.where("created_at >= ? AND created_at <= ?", params[:start_date],params[:end_date] ).paginate(page: params[:page], per_page: 3) if params[:start_date].present? && params[:end_date].present?

    respond_to do |format|
      format.html
      @new_users =  User.new_users.where(id: params[:checkbox_value].split(","))  if params[:checkbox_value].present?
      format.csv { send_data@new_users? @new_users.to_csv : "No Data" }
    end
  end
  
end