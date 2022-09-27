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

  def fetch_property
    _weight_age = 0
    @property = []
    @property_list = ''
     if params[:using_polygon] == "true"
      array = eval(params[:polygon])
      array.each do |address|
        lat = address[:latitude]
        long = address[:longitude]
        address = Geocoder.search([lat, long])
        house_number = address.first.house_number
        city = address.first.city
        country = address.first.country
        property = Property.find_by("address ILIKE ? AND address ILIKE ? AND address ILIKE ?", "%#{house_number}%", "%#{city}%", "%#{country}%")
        unless property == nil
        property.weight_age = "100"
        @property << property
      end
    end
    @property
   elsif params[:using_zip_code] == "true"
      @property = Property.where(zip_code: params[:zip_code])
      @property.weight_age = "100"
      @property
   elsif params[:user_preference] == "true"
    debugger

      if @current_user.user_preference.present?
      property_list_having_bed_rooms = Property.ransack(price_lteq_any: @current_user.user_preference.min_bedrooms).result
      property_list_having_bed_rooms = Property.ransack(price_gteq_any: @current_user.user_preference.max_bathrooms).result
      _value = calculate_weightage(_weight_age,property_list_having_bed_rooms,14)
      _weight_age = _value if _value.present?
      property_list_having_style = Property.search_property_by_house_style(@current_user.user_preference.property_style) ||
        Property.search_property_by_condo_style(@current_user.user_preference.property_style)
      _value = calculate_weightage(_weight_age,property_list_having_style,14)
      _weight_age = _value if _value.present?
      property_list_having_type = Property.search_property_by_house_type(@current_user.user_preference.property_type) ||
        Property.search_property_by_condo_type(@current_user.user_preference.property_type)
      _value = calculate_weightage(_weight_age,property_list_having_type,14)
      _weight_age = _value if _value.present?
      _weight_age = _value if _value.present?
      property_list_having_price = Property.ransack(price_lteq_any: @current_user.user_preference.min_price).result
      property_list_having_price = Property.ransack(price_gteg: @current_user.user_preference.max_price).result
      _value = calculate_weightage(_weight_age,property_list_having_price,14)
      _weight_age = _value if _value.present?
      property_list_having_frontage_unit = Property.search_property_by_lot_frontage_unit(@current_user.user_preference.min_lot_frontage)
      _value = calculate_weightage(_weight_age,property_list_having_frontage_unit,14)
      _weight_age = _value if _value.present?
      @property_list = (property_list_having_bed_rooms+
        property_list_having_style+ property_list_having_price+
        property_list_having_frontage_unit+
        property_list_having_type)&.uniq
      @property_list.each do |record|
        record.weight_age = _weight_age
        @property << record
      end
      else
       @property
      end

   else
      render json: {message: "Please give user preference, zip code or polygon"},status: :ok
   end
  end


  def calculate_weightage(_weight_age,matching_item,number)
    _weight_age = _weight_age + number if matching_item.present?
  end

  def fetch_by_zip_code
    property = Property.find_by(zip_code: params[:zip_code])
    if property.present?
      address = Geocoder.search(params[:zip_code])
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
