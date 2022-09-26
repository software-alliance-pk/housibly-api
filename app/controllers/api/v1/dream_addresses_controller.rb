class Api::V1::DreamAddressesController < Api::V1::ApiController
  def create
    if params[:location].present?
      @address = @current_user.dream_addresses.build(location: params[:location])
      if @address.save
        @address
      else
        render_error_messages(@address)
      end
    else
      render json: { message: "Location parameter is missing" }, status: :ok
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
      address = Property.where("address ILIKE ? AND address ILIKE ? AND address ILIKE ?", "%#{house_number}%", "%#{city}%", "%#{country}%")
      unless address == nil
        addresses << address
      end
    end
    if addresses.present?
      render json: { message: addresses }, status: :ok
    else
      render json: { message: addresses }, status: :ok
    end
  end

  def fetch_by_zip_code
    property = Property.find_by(zip_code: params[:zip_code])
    if property.present?
      address = Geocoder.search("params[:zip_code]")
      render json: { message: address }, status: :ok
    else
      render json: { message: "No Address available" }
    end
  end

  def index
    @dream_addresses = @current_user.dream_addresses
    if @dream_addresses.present?
      @dream_addresses
    else
      render json: { message: @dream_address }, status: :ok
    end
  end

  def destroy
    if params[:id].present?
      @dream_address = DreamAddress.find_by(id: params[:id])
      if @dream_address.present?
         @dream_address.destroy
         render json: { message: "successfully deleted" }, status: :ok
      else
        render json: { message: @dream_address }, status: :ok
      end
    else
      render json: { message: "Dream address id is missing" }, status: :ok
    end
  end

end
