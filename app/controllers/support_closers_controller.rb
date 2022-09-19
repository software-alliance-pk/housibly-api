class SupportClosersController < ApplicationController
  def index
    unless params[:search].blank?
      @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 10)
      @support_closer = @support_closer.custom_search(params[:search])
      response_to_method
    else
      @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 10)
      response_to_method
    end
  end

  def response_to_method
    respond_to do |format|
      format.html
      @support_closer =  User.get_support_closer_user.where(id: params[:checkbox_value].split(","))  if params[:checkbox_value].present?
      format.csv { send_data @support_closer?@support_closer.to_csv : "Data not found"  }
    end
  end

   def active_user
    @user = User.find_by(id: params[:id])
      if @user.update(active: true)
      redirect_to support_closers_path
    else
      redirect_to support_closers_path

    end
  end


  def deactive_user
     @user = User.find_by(id: params[:id])
      if @user.update(active: false)
      redirect_to support_closers_path
    else
      redirect_to support_closers_path
    end
  end
end