class Api::V1::PaymentsController < Api::V1::ApiController
  Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
  Stripe.api_key = 'sk_test_51LNZ3BAsady3KIaWsrai2Zq9cT9PCOp5s8AF6JjSyutqxodm7ESoI8EFCKtfC5Cd79CxcklRNVD76aOBwP8XnpO400X2CvQDdP' if Rails.env.production?

  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :set_default_card]

  def create
    customer = check_customer_at_stripe
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
      render json: { message: "card not found" }, status: 404
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
        user_cards_info = @current_user.card_infos
        find_first_card = user_cards_info&.first unless user_cards_info.pluck(:is_default).include?(true)
        if find_first_card
          find_first_card.update(is_default: true)
        end
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

  def set_default_card
    if @card
      @current_user.card_infos.update_all(is_default: false)
      @card.update(is_default: true)
    end
  end

  def get_default_card
    @card = @current_user.card_infos&.default_card
    if @card
      @card
    else
      render json: { message: "user has no card" }
    end
  end

  def charge_payment
  end

  def apple_pay
    # ApplePayService.apple_pay
  end

  private

  def find_card
    @card = CardInfo.find_by(card_id: payment_params[:id])
    if @card
      @card
    else
      render json: { message: "card not found" }
    end
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
