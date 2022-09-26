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
      array = eval(params[:polygon])
      array.each do |address|
      lat = address[:latitude]
      long = address[:longitude]
      address = Geocoder.search([lat, long])
      house_number = address.first.house_number
      city = address.first.city
      country = address.first.country
      address = Property.where("address ILIKE ? AND address ILIKE ? AND address ILIKE ?", "%#{house_number}%","%#{city}%","%#{country}%")
      unless address == nil
        addresses << address
      end
    end
    if addresses.present?
      render json: {message: addresses}, status: :ok
    else
      render json: {message: "Dream Address Not Foud"}, status: :ok
    end
  end

  def fetch_by_zip_code
    property = Property.find_by(zip_code: params[:zip_code])
    if property.present?
      address = Geocoder.search("params[:zip_code]")
      render json: {message: address},status: :ok
    else
      render json: {message: "No Address available"}
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
