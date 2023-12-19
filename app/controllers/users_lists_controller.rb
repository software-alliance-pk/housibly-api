class UsersListsController < ApplicationController
  require 'will_paginate/array'
  
  skip_before_action :authenticate_admin!
  def index
    notification = AdminNotification.find_by(id: params[:id])
    notification.update(read_at: Time.now) if notification.present?
  
    unless params[:search].blank?
      @all_users = User.all_users.custom_search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    else
      @all_users = User.all_users.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    end
    response_to_method
  end

  def user_profile
    @user = User.find_by(id: params[:id])
  end

  def response_to_method
    respond_to do |format|
      format.html
      @all_users =  User.where(id: params[:checkbox_value].split(","))  if params[:checkbox_value].present?
      format.csv { send_data @all_users.to_csv }
    end
  end

  def active_account
    @user = User.find_by(id: params[:id])
      if @user.update(active: true)
        notification = AdminNotification.where("action ILIKE ?", "#{@user.full_name} is active")
        unless notification.present?
          AdminNotification.create(actor_id: Admin.admin.first.id,
                                recipient_id: @user.id, action: "#{@user.full_name} is active") if Admin&.admin.present?
        end
      redirect_to users_lists_path
    else
      redirect_to users_lists_path

    end
  end

  def deactive_account
     @user = User.find_by(id: params[:id])
      if @user.update(active: false)
        notification = AdminNotification.where("action ILIKE ?", "#{@user.full_name} is deactive")
        unless notification.present?
          AdminNotification.create(actor_id: Admin.admin.first.id,
                                recipient_id: @user.id, action: "#{@user.full_name} is deactive") if Admin&.admin.present?
        end
      redirect_to users_lists_path
    else
      redirect_to users_lists_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AdminNotification.create(actor_id: Admin.admin.first.id,
                              recipient_id: @user.id, action: "New User Created") if Admin&.admin.present?
      redirect_to users_lists_path()
    else
      flash.alert = @user.errors.full_messages
      redirect_to users_lists_path()
    end
  end
  private

  def user_params
    params.permit(:full_name, :email, :password, :address,:description, :phone_number,
                  :user_type,:profile_type,:contacted_by_real_estate,:licensed_realtor)
  end

end