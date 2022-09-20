class UsersDataController < ApplicationController
  around_action :send_response_of_vacant_land, only: [:buy_vacant_land, :sell_vacant_land]
  around_action :send_response_of_condo, only: [:buy_condo, :sell_condo]
  around_action :send_response_of_house, only: [:buy_house, :sell_house]
  def index
    @all_users = User.paginate(page: params[:page], per_page: 10)
  end
  def buy_vacant_land
    @vacant_lands = VacantLand.paginate(page: params[:page], per_page: 10)
  end

  def sell_vacant_land
    @vacant_lands = VacantLand.paginate(page: params[:page], per_page: 10)
  end
  def user_info
    @users = User.paginate(page: params[:page], per_page: 10)
  end
  def dream_address
    @address =  DreamAddress.paginate(page: params[:page], per_page: 10)
  end

  def search_dream_address

  end

  def buy_condo
    @condos = Condo.paginate(page: params[:page], per_page: 10)
  end

  def sell_condo
    @condos = Condo.paginate(page: params[:page], per_page: 10)
  end

  def buy_house
    @houses = House.paginate(page: params[:page], per_page: 10)
    response_to_method(@houses)
  end

  def sell_house
    @houses = House.paginate(page: params[:page], per_page: 10)
  end

  private
  def response_to_method(data)
    respond_to do |format|
      format.html
      format.csv { send_data  data ?  data.to_csv : "Data not found"  }
    end
  end

  def send_response_of_vacant_land
    response_to_method(@vacant_lands)
  end

  def send_response_of_house
    response_to_method(@houses)
  end

  def send_response_of_condo
    response_to_method(@condos)
  end
end