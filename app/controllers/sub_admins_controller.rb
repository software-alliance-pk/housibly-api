class SubAdminsController < ApplicationController
  def index
    unless params[:search].blank?
      @sub_admins = Admin.custom_search(params[:search]).
      paginate(page: params[:page], per_page: 10)
    else
      @sub_admins = Admin.sub_admin.paginate(page: params[:page], per_page: 10)
    end
    

  end
end