class Api::V1::PaymentsController < Api::V1::ApiController
  Stripe.api_key = Rails.application.credentials.stripe[:api_key]
  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :default_card]

  def create
    customer =  check_customer_at_stripe
    card = StripeService.create_card(customer.id, payment_params[:token])
    @card = create_user_payment_card(card)
    make_first_card_as_default
    if @card
      @card
    else
      render_error_messages(@card)
    end
  end

  def get_card
    if @card
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
    if @card.present?
      if @card.destroy
        render json: { message: "Card deleted successfully!" }, status: 200
      else
        render_error_messages(@card)
      end
    end
  end

  def update_card
    if @card&.update(name: payment_params[:name], country: payment_params[:country])
      @card
    else
      render_error_messages(@card)
    end
  end

  def default_card
    if @card
      @current_user.card_infos.update_all(is_default:false)
      @card.update(is_default: true)
    end
  end

  private

  def find_card
    @card = CardInfo.find_by(card_id: payment_params[:id])
  end

  def check_customer_at_stripe
    if @current_user.stripe_customer_id.present?
      customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id) rescue nil
    else
      customer = StripeService.create_customer(payment_params[:name], @current_user.email)
      @current_user.update(stripe_customer_id: customer.id) rescue nil
    end
    return customer
  end

  def make_first_card_as_default
    @current_user.card_infos.update(is_default: true) if @current_user.card_infos.count < 2
  end

  def create_user_payment_card(card)
    @current_user.card_infos.create(
      card_id: card.id, exp_month: card.exp_month,
      exp_year: card.exp_year, last4: card.last4,
      brand: card.brand, country: payment_params[:country],
      fingerprint: card.fingerprint, name: payment_params[:name]
    )
  end

  def payment_params
    params.require(:payment).permit(:token, :name, :id, :country)
  end
end
