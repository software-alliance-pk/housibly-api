class Api::V1::UserMatchAddressesController < Api::V1::ApiController
	def create
		# debugger
		address = UserMatchAddress.find_by("address ILIKE ?", "%#{params[:address]}%")
		unless address.present?
			address = UserMatchAddress.create(address: params[:address])
			if address.save
				user = @current_user.user_search_addresses.build(user_match_address_id: address.id)
				if user.save
					render json: {address: address, user:user}, status: :ok
				else
					render_error_messages(user)
				end
			else
				render_error_messages(address)
			end
		else
			user = @current_user.user_search_addresses.build(user_match_address_id: address.id)
			if user.save
			  render json: {address: address, user:user}, status: :ok
			else
				render_error_messages(user)
			end
		end
	end

	def users_detail
		# debugger
		address = UserMatchAddress.find_by("address ILIKE ?", "%#{params[:address]}%")
		if address.present?
		  @users = UserSearchAddress.where(user_match_address_id:address.id)
		  @users
	  else
		  render json: {message: "No Found"},status: :ok
	  end
	end


end
