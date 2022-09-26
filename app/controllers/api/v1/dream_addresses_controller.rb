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
    property_list = ''
    if params[:polygon].present?
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
    elsif params[:zip_code].present?

    elsif params[:user_preference].present?
      property_list = Property.search_property_by_total_number_of_rooms(params[:number_of_rooms])
      property_list = Property.search_property_by_total_parking_spaces(params[:number_of_parking_spaces])
      property_list = Property.search_property_by_bed_rooms(params[:bed_rooms])
      property_list = Property.search_property_by_title(params[:title])
      property_list = Property.search_property_by_house_style(params[:house_style])
      property_list = Property.search_property_by_house_type(params[:house_type])
      property_list = Property.search_property_by_air_conditioner(params[:air_conditioner])
      property_list = Property.search_property_by_price(params[:price])
      property_list = Property.search_property_by_condo_type(params[:condo_type])
      property_list = Property.search_property_by_condo_style(params[:condo_style])
      property_list = Property.search_property_by_lot_frontage_unit(params[:frontage_unit])
      property_list = Property.search_property_by_lot_depth_unit(params[:depth_unit])
      property_list = Property.search_property_by_garage_spaces(params[:garage_spaces])
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
