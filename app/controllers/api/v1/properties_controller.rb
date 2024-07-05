# frozen_string_literal: true

class Api::V1::PropertiesController < Api::V1::ApiController
  require 'uri'

  before_action :validate_property_type, only: [:update, :create]
  before_action :check_number_of_images, only: [:update, :create]
  before_action :set_property, only: [:show, :update, :destroy]
  before_action :validate_polygon, only: :find_in_polygon
  before_action :validate_origin, only: :find_in_circle

  def index
    @properties = @current_user.properties.order('created_at desc')
  end

  def show; end # for getting a specific property

  def create
    @property = property_params[:property_type].titleize.gsub(' ', '').constantize.new(property_params)
    @property.user = @current_user
    unless @property.save
      render_error_messages(@property)
    end
  end

  def update
    @property.type = property_params[:property_type].titleize.gsub(' ', '').constantize
    unless @property.update(@image_arr.length > 0 ? property_params : property_params.except(:images))
      render_error_messages(@property)
    end
  end

  def destroy
    if @property.destroy
      render json: { message: 'Property has been deleted successfully!' }
    else
      render_error_messages(@property)
    end
  end

  def detail_options
    render json: Property.detail_options
  end

  def details_by_property_id
    property = Property.find_by_id(params[:property_id])

    if property
      render json: {
        property: property.as_json,
        last_seen: property.user&.last_seen.present? ? "#{time_ago_in_words(property.user.last_seen)} ago" : "",
        is_new: property.created_at > 6.weeks.ago,
        rooms: property.rooms.map { |room| render_room_json(room) },
        images: property.images.map do |image|
          { id: image.signed_id, url: begin rails_blob_url(image) rescue "" end }
        end,
        user: property.user.as_json
      }
    else
      render json: { error: 'Property not found' }, status: :not_found
    end
  end

  def matching_properties
    if @current_user.user_preference.present?
      @current_user.user_preference.preference_properties.destroy_all if @current_user.user_preference.preference_properties.any?
      @properties = Property.not_from_user(@current_user.id)
      .where(type: @current_user.user_preference['property_type'].titleize.gsub(' ', ''))
      @properties.map do |property|
        match_percentage = PropertiesSearchService.calculate_match_percentage(@current_user.user_preference.attributes, page_info, @current_user.id,property)
        PreferenceProperty.find_or_create_by(
          user_preference_id: @current_user.user_preference.id,
          property_id: property.id,
          match_percentage: match_percentage
        ) if match_percentage > 70
      end
      @preference_properties = @current_user.user_preference.preference_properties.where("match_percentage > ?", 70)
      # @properties = PropertiesSearchService.search_by_preference(@current_user.user_preference.attributes, page_info, @current_user.id)
      render 'matching_properties'
    else
      render json: { message: 'User has no preference' }
    end
  end

  def buy_properties_listing
    if @current_user.user_preference.present?
      @current_user.user_preference.preference_properties.destroy_all if @current_user.user_preference.preference_properties.any?
      @properties = Property.not_from_user(@current_user.id)
      .where(type: @current_user.user_preference['property_type'].titleize.gsub(' ', ''))
      @properties.map do |property|
        match_percentage = PropertiesSearchService.calculate_match_percentage(@current_user.user_preference.attributes, page_info, @current_user.id,property)
        PreferenceProperty.find_or_create_by(
          user_preference_id: @current_user.user_preference.id,
          property_id: property.id,
          match_percentage: match_percentage
        ) if match_percentage >= 50 && match_percentage <= 70
      end
      @preference_properties = @current_user.user_preference.preference_properties.where("match_percentage BETWEEN ? AND ?",50,70)
      # @properties = PropertiesSearchService.search_by_preference(@current_user.user_preference.attributes, page_info, @current_user.id)
      render 'matching_properties'
    else
      render json: { message: 'User has no preference' }
    end
  end

  def find_in_circle
    if search_params[:radius].present?
      @properties = PropertiesSearchService.search_in_circle(@origin, search_params[:radius], page_info, @current_user.id)
      render 'index'
    else
      render json: { message: 'Radius parameter is missing' }, status: :unprocessable_entity
    end
  end

  def find_in_polygon
    @properties = PropertiesSearchService.search_in_polygon(@polygon, page_info, @current_user.id)
    render 'index'
  end

  def find_by_zip_code
    if search_params[:zip_code].present?
      coordinates = LocationFinderService.get_coordinates_by_zip_code(search_params[:zip_code], @current_user.country_name)
      @properties = coordinates.blank? ? [] : PropertiesSearchService.search_in_circle(coordinates, 10, page_info, @current_user.id)
      render 'index'
    else
      render json: { message: 'Zip code parameter is missing' }, status: :unprocessable_entity
    end
  end

  def recent_properties
    @properties = @current_user.properties.where('created_at >= :five_days_ago', :five_days_ago => 5.days.ago)
    render 'index'
  end

  def matching_property
    _weight_age = 0
    if @current_user.user_preference.present?
      @properties = UserPreferencesService.new.search_property(@current_user)
      if @properties.present?
        @properties&.sort_by{|e| e[:created_at]}
      else
        render json: { message: 'Matching property not found' }, status: :unprocessable_entity
      end
    else
      render json: {}, status: :ok
    end
  end

  def matching_dream_address
    @properties = []
    @property_list = Property.where('address ILIKE (?)',@current_user.dream_addresses.pluck(:location))
    @property_list.each do |record|
      record.weight_age = _weight_age
      @properties << record
    end
    if @properties.present?
      render json: { message:  @properties }, status: :ok
    else
      render json: @properties, status: :ok
    end
  end

  private

    def property_params
      params.require(:property).permit(:address, :appliances_and_other_items, :balcony, :bath_rooms, :bed_rooms,
        :central_vacuum, :condo_corporation_or_hqa, :condo_fees, :condo_style, :condo_type, :currency_type,
        :driveway, :exposure, :garage_spaces, :house_style, :house_type, :is_lot_irregular, :laundry, :locker,
        :lot_depth, :lot_depth_unit, :lot_description, :lot_frontage, :lot_frontage_unit, :lot_size, :lot_size_unit,
        :pets_allowed, :pool, :price, :property_description, :property_tax, :property_type, :security, :sewer, :tax_year,
        :title, :total_number_of_rooms, :total_parking_spaces, :unit, :water, :year_built, air_conditioner: [],
        basement: [], exterior: [], fireplace: [], heat_source: [], heat_type: [], included_utilities: [], images: [],
        rooms_attributes: [:id, :_destroy, :name, :room_length, :room_width, :level, :room_measurement_unit]
      )
    end

    def search_params
      params.require(:search).permit(:zip_code, :radius, :origin, :polygon)
    end

    def set_property
      @property = Property.find_by(id: params[:id])
      render json: { message: 'Property does not exist' }, status: :not_found unless @property
    end

    def validate_property_type
      return if property_params[:property_type].in? ['house', 'condo', 'vacant_land']
      render json: { message: 'Property type should be one of the following: house, condo, vacant_land' }, status: 422
    end

    def validate_origin
      @origin = JSON.parse(search_params[:origin]) rescue nil
      return if valid_coordinates?(@origin)
      render json: { message: 'Invalid value for origin' }, status: :unprocessable_entity
    end

    def validate_polygon
      @polygon = JSON.parse(search_params[:polygon]) rescue nil
      return if @polygon.is_a?(Array) && @polygon.length >= 3 && @polygon.none?{|point| !valid_coordinates?(point)}
      render json: { message: 'Invalid value for polygon' }, status: :unprocessable_entity
    end

    def valid_coordinates?(point)
      point.is_a?(Hash) && point['lat'].present? && point['lng'].present?
    end

    def check_number_of_images
      @image_arr = property_params[:images].blank? ? [] : property_params[:images]
      unless @image_arr.length <= 30
        render json: { message: 'Images should not be more than 30' }, status: :unprocessable_entity
      end
    end

    def upload_image_to_cloudinary(image)
      begin
        require 'down'
        tempfile = Down.download(image['uri'])
        @property.images.attach(io: File.open(image['uri']), filename: image['name'], content_type: image['type'])
      rescue => e
        render json: { message: e.message }, status: 404
      end
    end

    def calculate_weightage(_weight_age,matching_item,number)
      _weight_age = _weight_age + number if matching_item.present?
    end

    def page_info
      {
        page: params[:page],
        per_page: 10
      }
    end

    def render_room_json(room)
      {
        id: room.id,
        name: room.name,
        room_length: room.room_length,
        room_width: room.room_width,
        level: room.level
      }
    end
end
