class Api::V1::ReportingController < Api::V1::ApiController
	def create
		@report = @current_user.reportings.build
		@report.reported_user_id = params[:reported_user]
		if @report.save
			@ticket = Support.create(ticket_number: generate_ticket_number,
		  user_id: @current_user.id,status: "pending",
		  description:"please take action against this user")
		  if @ticket.save
		  	@ticket
		  else
		  	render_error_messages(@ticket)
		  end
		  conv_type = current_user.want_support_closer? ? "support_closer" : "end_user"
			@conversation = SupportConversation.create(
			recipient_id: Admin.admin.first.id,sender_id:current_user.id,
			conv_type: conv_type, support_id: @ticket.id)
			if @conversation.save
				@conversation
			else
				render_error_messages(@conversation)
			end
		else
			render_error_messages(@report)
		end
	end

	def report_conversation
		#debugger
		@conversation = SupportConversation.find_by(support_id: params[:support_id])
	    unless @conversation.present?
	      support = Support.find_by(id: params[:support_id])
	      @conversation = support.build_support_conversation
	      @conversation.sender_id = @current_user.id
	      @conversation.recipient_id = Admin.first.id
	      if current_user.want_support_closer?
	        @conversation.update(conv_type: "support_closer")
	      else
	        @conversation.update(conv_type: "end_user")
	      end
	      if @conversation.save
	       @conversation
	      else
	        render_error_messages(@conversation)
	      end
	    else
	      render json: {message: @conversation},status: :ok
	    end
	end


def generate_ticket_number
    @ticket_number = loop do
      random_token = SecureRandom.urlsafe_base64(6, false)
      break random_token unless Support.exists?(ticket_number: random_token)
    end
  end			
end

