class SubAdminsController < ApplicationController
  def index
    notification = AdminNotification.find_by(id:params[:id])
    notification.update(read_at:Time.now) if notification.present?
    unless params[:search].blank?
      @sub_admins = Admin.custom_search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      response_to_method
    else
      @sub_admins = Admin.sub_admin.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
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
      notification = AdminNotification.where("action ILIKE ?", "#{@sub_admin.user_name} Sub Admin is active")
      unless notification.present?
        AdminNotification.create(actor_id: Admin.admin.first.id,
                              recipient_id: User.last.id, action: "#{@sub_admin.user_name} Sub Admin is active") if Admin&.admin.present? && User.last.present?
      end
      redirect_to sub_admins_path
    else
      redirect_to sub_admins_path
    end
  end

  def deactive_admin
    @sub_admin = Admin.find_by(id: params[:id])
    if @sub_admin
      @sub_admin.update(status: false)
      notification = AdminNotification.where("action ILIKE ?", "#{@sub_admin.user_name} Sub Admin is deactive")
      unless notification.present?
        AdminNotification.create(actor_id: Admin.admin.first.id,
                              recipient_id: User.last.id, action: "#{@sub_admin.user_name} Sub Admin is deactive") if Admin&.admin.present? && User.last.present?
      end
      redirect_to sub_admins_path
    else
      redirect_to sub_admins_path
    end
  end

  def create
    @sub_admin = Admin.new(sub_admin_params)
    @sub_admin.date_of_birth = Date.today
    if @sub_admin.save
      AdminNotification.create(actor_id: Admin.admin.first.id,
                              recipient_id: User.last.id, action: "New Admin Created") if Admin&.admin.present? && User&.last.present?
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