# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::ApiController
  include ChatListBoardCast

  def show_profile
    @current_user
  end

  def show_other_user_profile
    @user = User.find_by(id: params[:user_id])
    return render json: { message: 'User not found' }, status: :not_found unless @user

    return render json: { message: 'Other user cannot be the same as the current user' }, status: 422 if @current_user.id == @user.id

    visitor = Visitor.find_by(user_id: @user.id, visit_id: @current_user.id)
    if visitor.present?
      visitor.touch # updates the updated_at timestamp
    else
      @user.visitors.create(visit_id: @current_user.id)
    end
  end

  def update_profile
    if @current_user.update(user_params.merge(profile_complete: true))
      render 'show_profile'
    else
      render_error_messages(@current_user)
    end
  end

  def profile_visitor_list
    @visits = @current_user.visitors
  end

  def delete_account
    if @current_user.destroy
      render json: { message: 'Account deleted successfully' }
    else
      render_error_messages(@current_user)
    end
  end

  def search_support_closers
    if @current_user.latitude.present? && @current_user.longitude.present?
      @support_closers =
        User.support_closer.custom_search(params[:search_query]).within(15, origin: [@current_user.latitude, @current_user.longitude]).paginate(page_info)
    else
      @support_closers = User.support_closer.custom_search(params[:search_query]).paginate(page_info)
      # @support_closers =
      #   User.support_closer.custom_search(params[:search]).joins(:subscription).where.not(subscription: {status: 'canceled'}).paginate(page_info)
    end
  end

  def report_unreport_user
    user = User.find_by(id: params[:user_id])
    conversation = Conversation.find_by(recipient_id: user.id, sender_id: @current_user.id) || Conversation.find_by(recipient_id: @current_user.id, sender_id: user.id)

    if conversation.present?
      if params[:is_reported].present? && params[:is_reported] == 'true'
        if user.update(is_reported: true)
          render json: { message: 'User reported successfully' }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      elsif params[:is_reported].present? && params[:is_reported] == 'false'
        if user.update(is_reported: false)
          render json: { message: 'User is removed from the report list' }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    else
      render json: { message: 'Conversation not found' }, status: :not_found
    end
  end

  def block_unblock_user
    user = User.find_by(id: params[:user_id])
    conversation = Conversation.find_by(recipient_id: user.id, sender_id: @current_user.id) || Conversation.find_by(recipient_id: @current_user.id, sender_id: user.id)

    if conversation.present?
      if params[:is_blocked].present? && params[:is_blocked] == 'true'
        if conversation.update(is_blocked: true, block_by: @current_user.id)
          render json: { message: 'User added to blacklist' }, status: :ok
        else
          render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
        end
      elsif params[:is_blocked].present? && params[:is_blocked] == 'false'
        if conversation.update(is_blocked: false, block_by: nil)
          render json: { message: 'User removed from blacklist' }, status: :ok
        else
          render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
        end
      end
    else
      render json: { message: 'Conversation not found' }, status: :not_found
    end
  end

  def blocked_users
    @conversation_blocked = Conversation.where('(recipient_id = (?) OR  sender_id = (?)) AND is_blocked = (?)', @current_user.id, @current_user.id, true)
    if @conversation_blocked.present?
      @conversation_blocked
    else
      render json: { message: 'No Blocked Conversations Found' }
    end
  end

  def unblocked_users
    @conversation_unblocked = Conversation.where('(recipient_id = (?) OR sender_id = (?)) AND is_blocked = (?)', @current_user.id, @current_user.id, false)
    if @conversation_unblocked.present?
      @conversation_unblocked
    else
      render json: { message: 'No Unblocked Conversations Found' }
    end
  end

  def reported_users
    @reported_users = User.where(is_reported: true)
    if @reported_users.present?
      @reported_users
    else
      render json: { reported_users: 'No Found' }
    end
  end

  def update_notification
    @settings = @current_user.user_setting
    if params[:push_notification].present?
      if params[:push_notification] == 'false'
        @settings.update(push_notification: false)
        render json: { message: 'Push Notification OFF' }, status: :ok
      else
        @settings.update(push_notification: true)
        render json: { message: 'Push Notification ON' }, status: :ok
      end
    elsif params[:inapp_notification].present?
      if params[:inapp_notification] == 'false'
        @settings.update(inapp_notification: false)
        render json: { message: 'In App Notification OFF' }, status: :ok
      else
        @settings.update(inapp_notification: true)
        render json: { message: 'In App Notification ON' }, status: :ok
      end
    else
      if params[:email_notification] == 'false'
        @settings.update(email_notification: false)
        render json: { message: 'In App Notification OFF' }, status: :ok
      else
        @settings.update(email_notification: true)
        render json: { message: 'In App Notification ON' }, status: :ok
      end
    end
  end

  def get_notification_setting
    @settings = @current_user.user_setting
  end

  def get_school_pins
    if params[:location_cordinates].present?
      long = eval(params[:location_cordinates])[0][:longitude]
      puts long
      lat =eval(params[:location_cordinates])[0][:latitude]
      puts lat
      geocoder_address = Geocoder.search([lat,long]).first
      puts geocoder_address
      address = geocoder_address.address
      city = geocoder_address.city
      country = geocoder_address.country
      puts country
      puts city
      puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<OUT SIDE <<<<<<<<<<<<<<<<<<<<<<'
      @school_pins = SchoolPin.where('(city ILIKE ? AND country ILIKE ?) OR (address ILIKE ?)', "%#{city}%", "%#{country}%", "%#{address}%")
      if @school_pins.present?
        puts '<<<<<<<<<<<<<<<<<<<INSIDE THE METHOD<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
        puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
        @school_pins
      else
        render json: {message: 'No school match with this address'}, status: :ok
      end
    else
      render json: {message: 'Please give suitable parameters'}, status: :unprocessable_entity
    end
  end

  def get_school
    if params[:school_id].present?
      @school_pin = SchoolPin.find_by(id: params[:school_id])
      if @school_pin.present?
        @school_pin
      else
        render json: {message: 'School pin is not present against this ID'}, status: :ok
      end
    else
      render json: { message: 'School id parameter is missing' }, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:full_name, :email, :password, :phone_number, :description,
        :currency_amount, :country_code, :country_name, :avatar, :hourly_rate, :latitude, :longitude, :address,
        images: [], certificates: [], professions_attributes: [:id, :_destroy, :title],
        schedule_attributes: [:id, :ending_time, :starting_time, working_days: []]
      )
    end

    def page_info
      {
        page: params[:page],
        per_page: 10
      }
    end
end
