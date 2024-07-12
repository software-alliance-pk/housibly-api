class UserVerificationMailer < ApplicationMailer

  def send_otp_to_email
    @user = params[:user]
    mail(to: @user.email, subject: "#{params[:subject]}")
  end

  def send_signup_otp
    @user = params[:user]
    mail(to: @user.email, subject: "#{params[:subject]}")
  end
  def resend_new_otp
    @user = params[:user]
    mail(to: @user.email, subject: "#{params[:subject]}")
  end

end