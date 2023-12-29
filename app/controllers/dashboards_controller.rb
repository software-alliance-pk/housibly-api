class DashboardsController < ApplicationController
  def index
    notification = AdminNotification.find_by(id: params[:id])
    notification.update(read_at: Time.now) if notification.present?
    @new_users = User.new_users.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
  
    @start_date = params[:start_date].to_date if params[:start_date].present?
    @end_date = params[:end_date].to_date if params[:end_date].present?
    @new_users = User.new_users.where("created_at >= ? AND created_at <= ?", @start_date.beginning_of_day, @end_date.end_of_day).paginate(page: params[:page], per_page: 3) if @start_date.present? && @end_date.present?   
    @new_users = User.new_users.where(id: params[:checkbox_value].split(",")) if params[:checkbox_value].present? && request.format.csv?
    
    respond_to do |format|
      format.html
      format.csv { send_data @new_users ? @new_users.to_csv : "No Data" }
    end
  end

end