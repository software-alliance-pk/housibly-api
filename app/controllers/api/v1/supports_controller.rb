class Api::V1::SupportsController < Api::V1::ApiController
  def create_ticket
    @ticket = current_user.supports.new(support_params.merge(ticket_number: generate_ticket_number.upcase))
    if @ticket.save
      conv_type = current_user.support_closer? ? "support_closer" : "end_user"
      @conversation = @ticket.build_support_conversation(recipient_id: Admin.admin.first.id, sender_id:@current_user.id, conv_type: conv_type)
      if @conversation.save
        @current_user.user_support_messages.build(body: @ticket.description, image: support_params[:image], support_conversation_id: @conversation.id).save
      else
        render_error_messages(@conversation)
      end
      AdminNotification.create(actor_id: Admin.admin.first.id,
                              recipient_id: current_user.id, action: "#{current_user.full_name} generated new ticket") if Admin&.admin.present?
      @ticket
    else
      render_error_messages(@ticket)
    end
  end

  def get_tickets
    @tickets = current_user.supports.order("created_at desc")
    if @tickets
      @tickets
    else
      render_error_messages(@tickets)
    end
  end

  def generate_ticket_number
    @ticket_number = loop do
      random_token = SecureRandom.urlsafe_base64(6, false)
      break random_token unless Support.exists?(ticket_number: random_token)
    end
  end

  private

  def support_params
    params.require(:support).permit(:id, :ticket_number, :status, :description, :image)
  end

end
