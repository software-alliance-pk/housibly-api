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

  def block_unblock_user
    user = User.find_by(id: params[:user_id])
    conversation = Conversation.find_by(recipient_id: user.id,sender_id: user.id)
    if conversation.present?
      if params[:is_blocked].present? && params[:is_blocked] == "true"
        if conversation.update(is_blocked: params[:is_blocked])
          render json: {message: "User added in blacklist"},status: :ok
        end
      elsif params[:is_blocked].present? && params[:is_blocked] == "false"
        if conversation.update(is_blocked: params[:is_blocked])
          render json: {message: "User removed from blacklist"},status: :ok
        end
      end
    else
      render json: {message:[]}, status: :ok
    end
  end



  def blocked_users
    @conversation_blocked = Conversation.where("recipient_id = (?) OR  sender_id = (?) AND is_blocked = (?)", @current_user.id, @current_user.id,true)
    if @conversation_blocked.present?
      @conversation_blocked
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

  def view_user_profile
    @user = User.find_by(id: params[:user_id])
  visitor = Visitor.find_by(user_id: @user.id, visit_id: @current_user.id)
  if visitor.present?
    visitor.update(created_at: Time.now)
  else
    @user.visitor.build(visit_id: @current_user.id).save
  end
  end

  def profile_visitor_list
    @visitor = @current_user.visitor
    if @visitor.present?
      @visitor
    else
      render json: {visitor: []},status: :ok
    end
  end

  private

  def sup_closer_params
     params.require(:user).
      permit(:full_name, :email, :phone_number, :description,
     :currency_amount, :country_code, :country_name, :avatar,images: [])
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
