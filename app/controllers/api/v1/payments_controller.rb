class Api::V1::PaymentsController < Api::V1::ApiController
  require 'stripe'
  Stripe.api_key = 'sk_test_51LNZ3BAsady3KIaWsrai2Zq9cT9PCOp5s8AF6JjSyutqxodm7ESoI8EFCKtfC5Cd79CxcklRNVD76aOBwP8XnpO400X2CvQDdP'

  def create
    if @current_user.stripe_customer_id.present?
      customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id) rescue nil
    else
      customer = StripeService.create_customer(payment_params[:name], @current_user.email)
      @current_user.update(stripe_customer_id: customer.id) rescue nil
    end
    card = StripeService.create_card(customer.id, payment_params[:token])
    if @card = @current_user.card_infos.create(card_id: card.id, exp_month: card.exp_month,
                                               exp_year: card.exp_year, last4: card.last4,
                                               brand: card.brand, country: payment_params[:country],
                                               fingerprint: card.fingerprint, name: payment_params[:name])
    else
      render_error_messages(@card)
    end
  end

  def get_card
    if @card = CardInfo.find_by(card_id: payment_params[:id])
      @card
    else
      render_error_messages(@card)
    end
  end

  def get_all_cards
    if @cards = @current_user.card_infos
      @cards
    else
      render_error_messages(@cards)
    end
  end

  def destroy_card
    @card = CardInfo.find_by(card_id: payment_params[:id])
    if @card.present?
      if @card.destroy
        render json: { message: "Card deleted successfully!" }, status: 200
      else
        render_error_messages(@card)
      end
    end
  end

  def update_card
    @card = CardInfo.find_by(card_id: payment_params[:id])
    if @card.update(name: payment_params[:name], country: payment_params[:country])
      @card
    else
      render_error_messages(@card)
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:token, :name, :id, :country)
  end
end
