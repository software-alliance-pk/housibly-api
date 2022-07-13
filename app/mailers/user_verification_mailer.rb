class UserVerificationMailer < ApplicationMailer

  def send_otp_to_email
    @user = params[:user]
    mail(to: @user.email, subject: "#{params[:subject]}")
  end

end