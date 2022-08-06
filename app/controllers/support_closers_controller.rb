class SupportClosersController < ApplicationController
  def index
    @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 1)
  end
end