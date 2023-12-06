class UsersDataController < ApplicationController
  def index
    notification = AdminNotification.find_by(id:params[:id])
    notification.update(read_at:Time.now) if notification.present?
    unless params[:search].blank?
      @all_users = User.custom_search(params[:search]).paginate(page: params[:page], per_page: 10)
    else
      @all_users = User.paginate(page: params[:page], per_page: 10)
    end
    response_to_method(@all_users)
  end

  def buy_vacant_land
    @vacant_lands = VacantLand.paginate(page: params[:page], per_page: 10)
    response_to_method(@vacant_lands)
  end

  def sell_vacant_land
    @vacant_lands = VacantLand.paginate(page: params[:page], per_page: 10)
    response_to_method(@vacant_lands)
  end

  def user_info
    @users = User.paginate(page: params[:page], per_page: 10)
    response_to_method(@users)
  end

  def property_profile
    @property = Property.find_by(id: params[:id])

  end

  def dream_address
    @address = DreamAddress.paginate(page: params[:page], per_page: 10)
  end

  def search_dream_address

  end

  def buy_condo
    @condos = Condo.paginate(page: params[:page], per_page: 10)
    response_to_method(@condos)
  end

  def sell_condo
    @condos = Condo.paginate(page: params[:page], per_page: 10)
    response_to_method(@condos)
  end

  def buy_house
    @houses = House.paginate(page: params[:page], per_page: 10)
    response_to_method(@houses)
  end

  def sell_house
    @houses = House.paginate(page: params[:page], per_page: 10)
    response_to_method(@houses)
  end

  private

  def response_to_method(data)
    respond_to do |format|
      format.html
      format.csv { send_data data ? data.to_csv : "Data not found" }
    end
  end
end