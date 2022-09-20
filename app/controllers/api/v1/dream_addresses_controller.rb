class Api::V1::DreamAddressesController < Api::V1::ApiController

  def create
    @address = @current_user.dream_addresses.build(location: params[:location])
    if @address.save
      @address
    else
      render_error_messages(@address)
    end
  end

  def fetch_address
    addresses = []
    array = [{longitude: -122.43728701025248, latitude: 37.797889657909224},{longitude: -122.4472276121378, latitude:37.780908226622195},{longitude: -122.43760518729687, latitude: 37.7661877060221},{longitude:-122.41223618388176, latitude: 37.778203173797294},{longitude: -122.41676945239305, latitude: 37.794808219787846}]
    
      array.each do |address|
      address = Geocoder.search("address")
      address = address.first.address
      # address = Property.where(address: address)
        addresses << address
    end
    if addresses.present?
      render json: {message: addresses}, status: :ok
    else
      render json: {message: "Dream Address Not Foud"}, status: :ok
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
