class SupportsController < ApplicationController
  def index

  end
  def active_user
    debugger
    @user = User.find_by(id: params[:id])
      if @user.update(active: true)
      redirect_to support_closers_path
    else
      redirect_to support_closers_path

    end
  end


  def deactive_user
    debugger
     @user = User.find_by(id: params[:id])
      if @user.update(active: false)
      redirect_to support_closers_path
    else
      redirect_to support_closers_path
    end
  end
end