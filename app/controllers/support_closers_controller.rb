class SupportClosersController < ApplicationController
  def index
    unless params[:search].blank?
      @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 1)
      @support_closer = @support_closer.custom_search(params[:search])
      respond_to do |format|
        format.html
        format.csv { send_data @support_closer.to_csv }
      end
    else
      @support_closer = User.get_support_closer_user.paginate(page: params[:page], per_page: 1)
      respond_to do |format|
        format.html
        format.csv { send_data @support_closer.to_csv }
      end
    end
  end
end