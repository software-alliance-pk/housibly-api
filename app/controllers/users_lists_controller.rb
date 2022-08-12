class UsersListsController < ApplicationController
  def index
    unless params[:search].blank?
      @all_users = User.all_users.custom_search(params[:search]).paginate(page: params[:page], per_page: 3)
      respond_to do |format|
        format.html
        format.csv { send_data @all_users.to_csv }
      end
    else
      @all_users = User.all_users.paginate(page: params[:page], per_page: 3)
      respond_to do |format|
        format.html
        format.csv { send_data @all_users.to_csv }
      end
    end
    

  end
end