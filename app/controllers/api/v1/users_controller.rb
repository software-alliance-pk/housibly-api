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
    
    if @support_closer.present?
      @support_closer
    else
      render json: {message: "Support Closer not found"},
      status: :unprocessable_entity
    end
  end

  def update_support_closer_profile
    if @current_user.present?
      @current_user.professions.destroy_all if @current_user.professions.present? 
      user_profession[:titles].each do |user|  
        @current_user.professions.build(title:user)
      end
      @current_user.assign_attributes(sup_closer_params)
        if @current_user.save(validate: false)
          @current_user
      else
        render_error_messages(@current_user)
      end
    else
      render json: {message: "Support Closer not found"}, status: :unprocessable_entity
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


  def blocked_users
    @blocked_users = User.where(is_blocked: true)
    if @blocked_users.present?
      @blocked_users
    else
      render json: {message: "No Found"}
    end
  end

  def unblocked_users
    @unblocked_users = User.where(is_blocked: false)
    if @unblocked_users.present?
      @unblocked_users
    else
      render json: {message: "No Found"}
    end
  end

  def reported_users
    @reported_users = User.where(is_reported: true)
    if @reported_users.present?
      @reported_users
    else
      render json: {reported_users: "No Found"}
    end
  end

  private

  def sup_closer_params
     params.require(:user).
      permit(:full_name, :email, :phone_number, :description,
     :currency_amount, :avatar,images: [])
  end
  def user_profession
     params.require(:user).permit(titles: [])
  end
  def user_params
    params.require(:user).
    permit(:email, :phone_number, :description, :country_code, :country_name,
    :avatar)
  end
end
