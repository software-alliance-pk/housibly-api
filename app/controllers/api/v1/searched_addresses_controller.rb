# frozen_string_literal: true

class Api::V1::SearchedAddressesController < Api::V1::ApiController

	def create
		@searched_address = SearchedAddress.find_by(searched_address_params.slice(:latitude, :longitude))
		if @searched_address
			@current_user.searched_addresses << @searched_address unless @current_user.searched_addresses.include? @searched_address
		else
			@searched_address = SearchedAddress.new(searched_address_params)
			if @searched_address.save
				@current_user.searched_addresses << @searched_address
			else
				render_error_messages(@searched_address)
			end
		end
	end

	# get users who searched for a given address based on latitude and longitude
	def get_users
		return render json: { message: 'latitude parameter is missing' } if searched_address_params[:latitude].blank?
		return render json: { message: 'longitude parameter is missing' } if searched_address_params[:longitude].blank?

		if params[:page].to_i < 2
			# run only for first page
			@total_user_count = SearchedAddress
				.within(1, origin: searched_address_params.slice(:latitude, :longitude).values)
				.joins(:users)
				.select('DISTINCT ON (users.id) users.id')
				.order('users.id desc')
				.size
		end

		user_ids = SearchedAddress
			.within(1, origin: searched_address_params.slice(:latitude, :longitude).values)
			.joins(:users)
			.select('DISTINCT ON (users.id) users.id')
			.order('users.id desc')
			.paginate(page_info)

		@users = User.where(id: user_ids.map{ |uid| uid if uid != @current_user.id }).includes(:user_preference)
	end

	private

		def searched_address_params
			params.require(:searched_address).permit(:address, :latitude, :longitude)
		end

		def page_info
      {
        page: params[:page],
        per_page: 10
      }
    end

end
