class SubAdminsController < ApplicationController
  def index
    unless params[:search].blank?
      @sub_admins = Admin.custom_search(params[:search]).paginate(page: params[:page], per_page: 10)
      response_to_method
    else
      @sub_admins = Admin.sub_admin.paginate(page: params[:page], per_page: 10)
      response_to_method
    end
  end

  def response_to_method
    respond_to do |format|
      format.html
      @sub_admins =  Admin.sub_admin.where(id: params[:checkbox_value].split(","))  if params[:checkbox_value].present?
      format.csv { send_data @sub_admins? @sub_admins.to_csv : "Data not found"  }
    end
  end

   def active_admin
     @sub_admin = Admin.find_by(id: params[:id])
    if @sub_admin
      @sub_admin.update(status: true)
      redirect_to sub_admins_path
    else
      redirect_to sub_admins_path
    end
  end

  def deactive_admin
    @sub_admin = Admin.find_by(id: params[:id])
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

  def sub_admin_params
    params.permit(:full_name, :email, :password, :user_name, :location, :phone_number, :date_of_birth)
  end
end