class SubAdminsController < ApplicationController
  before_action :set_admin, only: [:active_admin,:deactive_admin]
  def index
    unless params[:search].blank?
      @sub_admins = Admin.custom_search(params[:search]).paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.csv { send_data @sub_admins? @sub_admins.to_csv : "Data not found" }
      end
    else
      @sub_admins = Admin.sub_admin.paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.csv { send_data @sub_admins? @sub_admins.to_csv : "Data not found"  }
      end
    end
  end

   def active_admin
    if @sub_admin
      @sub_admin.update(status: true)
      redirect_to sub_admins_path
    else
      redirect_to sub_admins_path
    end
  end

  def deactive_admin
    if @sub_admin
      @sub_admin.update(status: false)
      redirect_to sub_admins_path
    else
      redirect_to sub_admins_path
    end
  end

  def create
    @sub_admin = Admin.new(sub_admin_params)
    if @sub_admin.save
      redirect_to sub_admins_path()
    else
      flash.alert = @sub_admin.errors.full_messages
     redirect_to sub_admins_path 
   end
  end
  private
  def set_admin
    @sub_admin = Admin.find_by(id: params[:id])
  end

  def sub_admin_params
    params.permit(:full_name, :email, :password, :user_name, :location, :phone_number, :date_of_birth)
  end
end