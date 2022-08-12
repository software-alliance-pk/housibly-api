class DashboardsController < ApplicationController
  def index
    @new_users = User.new_users.paginate(page: params[:page], per_page: 1)
    
    respond_to do |format|
      format.html
      format.csv { send_data @new_users.to_csv }
    end
 end
end