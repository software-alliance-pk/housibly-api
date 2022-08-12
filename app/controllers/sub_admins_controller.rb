class SubAdminsController < ApplicationController
  def index
    unless params[:search].blank?
      @sub_admins = Admin.custom_search(params[:search]).
      paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.csv { send_data @sub_admins.to_csv }
      end
    else
      @sub_admins = Admin.sub_admin.paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.csv { send_data @sub_admins.to_csv }
      end
    end
    

  end
end