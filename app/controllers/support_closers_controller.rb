class SupportClosersController < ApplicationController
  def index
    unless params[:search].blank?
      @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 10)
      @support_closer = @support_closer.custom_search(params[:search])
      respond_to do |format|
        format.html
        format.csv { send_data @support_closer.to_csv }
      end
    else
      @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.csv { send_data @support_closer.to_csv }
      end
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