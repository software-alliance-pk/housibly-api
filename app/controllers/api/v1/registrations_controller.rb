class Api::V1::RegistrationsController < ApiController

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { success: "confirmation email is sent" }, status: :ok
    else
      render json: { success: "Confirmation email sent" }, status: :ok
    end
  end

  private
  def user_params
    params.require(users).permit(:full_name, :email, :password, :password_confirmation)
  end
end
