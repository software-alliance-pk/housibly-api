class Api::V1::DreamAddressesController < Api::V1::ApiController

  def create
    @address = @current_user.dream_addresses.build(location: params[:location])
    if @address.save
      @address
    else
      render_error_messages(@address)
    end
  end


  def index
    @dream_addresses = @current_user.dream_addresses
    if @dream_addresses
      @dream_addresses
    else
      render json: {message: "Dream Address Not Foud"}, status: :ok
    end
  end
  def destroy
    @dream_address = DreamAddress.find_by(id: params[:id])
    if @dream_address.present?
      if @dream_address.destroy
        render json: {message: "successfully deleted"}, status: :ok
     end
   else
    render json: {message: "Dream Address Not Foud"}, status: :ok
    end
  end



end
