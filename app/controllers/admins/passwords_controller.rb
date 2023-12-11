# frozen_string_literal: true

class Admins::PasswordsController < Devise::PasswordsController
  def create
    if params[:admin][:email]==''
      redirect_to new_admin_password_path
      flash[:alert] = "Email can't be blank"
    elsif Admin.pluck(:email).include?(params[:admin][:email])
      $otp = 6.times.map{rand(10)}.join
      super
    else
      redirect_to new_admin_password_path
      flash[:alert] = "Invalid Email"
    end
  end
end
