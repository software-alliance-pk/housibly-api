class Api::V1::UsersController < Api::V1::ApiController
  def get_profile
    @current_user
  end

  def update_profile
    if @current_user.present?
      @current_user.assign_attributes(user_params)
      if @current_user.save(validate: false)
        @current_user
      else
        render_error_messages(@current_user)
      end
    else
      render_error_messages(@current_user)
    end
  end

  def search_support_closer
    @support_closers = User.want_support_closer.custom_search(params[:search])
    @support_closers = @support_closers.near("lahore", 70, units: :km)
    if @support_closers.present?
      @support_closers
    else
      render json: {message: "Support Closer not found"},
       status: :unprocessable_entity
    end
  end

  def support_closer_profile
    @support_closer = User.find_by(id: params[:support_closer_id])
    if @support_closer.want_support_closer?
      @support_closer
    else
      render json: {message: "Support Closer not found"},
      status: :unprocessable_entity
    end
  end

  def get_support_closers
    @support_closers = User.want_support_closer.near("karachi", 70, units: :km)
    if @support_closers.present?
      @support_closers
    else
      @support_closers = User.want_support_closer
    end
  end

  private

  def user_params
    params.require(:user).
    permit(:email, :phone_number, :description, :country_code, :country_name,
    :avatar)
  end
end
