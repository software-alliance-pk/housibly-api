class UsersDataController < ApplicationController
  def index
    @all_users = User.all

  end
  def buy_vacant_land
    @vacant_lands = VacantLand.all 
  end

  def sell_vacant_land
@vacant_lands = VacantLand.all
  end
  def user_info
    @users = User.all

  end
  def dream_address
  end

  def buy_condo
    @condos = Condo.all
  end

  def sell_condo
@condos = Condo.all
  end

  def buy_house
    @houses = House.all
  end

  def sell_house
@houses = House.all
  end
end