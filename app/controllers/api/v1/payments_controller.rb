class Api::V1::PaymentsController < Api::V1::ApiController
  # Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
  Stripe.api_key = 'sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h'     # e.g. sk_live_...
  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :set_default_card]

  def create
    customer = check_customer_at_stripe
    stripe_token = payment_params[:token]
    card = StripeService.create_card(customer.id,stripe_token)
    return render json: { message: "Card is not created on Stripe" }, status: 422 if card.blank?
    @card = create_user_payment_card(card)
    make_first_card_as_default
    if @card
      @card
    else
      render_error_messages(@card)
    end
  end

  def create_package
    @product = StripeService.create_product(params[:package_name])
    price = Stripe::Price.create({unit_amount: params[:price],currency: 'usd',recurring: {interval: params[:recurring_interval]},product: @product.id,})
    Package.create(name: @product.name, price:price.unit_amount, stripe_package_id: @product.id, stripe_price_id: price.id)
    if @product
      render json: {package: @product, price: price},status: :ok
    else
      render_error_messages(@product)
    end
  end

  def get_pakeges
    @packages = Package.all
    if @packages.present?
      render json: {message: @packages},status: :ok
    else
     render json: {package: "No Package Available"},status: :ok
    end
  end

  def create_subscription
    customer = check_customer_at_stripe
    subscription = StripeService.create_subscription(customer.id,params[:price_id])
    if  subscription != false
      puts subscription
      @current_user.build_subscription(current_period_end: subscription.current_period_end,
                                      current_period_start: Time.now,interval: subscription.plan.interval,
                                      interval_count:subscription.plan.interval_count, price: subscription.plan.amount,
                                      status: subscription.status,subscription_title: "#{subscription.plan.interval_count} #{subscription.plan.interval}".upcase,
                                      ).save
      render json: {package: subscription},status: :ok
    else
      render json: {message: "Please enter your card"}, status: :unprocessable_entity
    end
  end
  def get_subscription
    subscriptions = Subscription.all
    if subscriptions.present?
      render json: {subscription: subscriptions},status: :ok
    else
     render json: {package: "No Package Available"},status: :ok
    end
  end
  def cancel_subscription
    subscription = Stripe::Subscription.delete(
    params[:subscription_id],
    )
    @current_user.subscription.update(status: subscription.status)
    if subscription.present?
     render json: {subscription: subscription.status},status: :ok
    end 
  end


  def get_card
    if @card.present?
      @card
    else
      render json: { message: "card not found" }, status: 404
    end
  end

  def get_all_cards
    if @cards = @current_user.card_infos
      @cards
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
      @current_user.card_infos.update_all(is_default: false) unless @card.is_default
      @card.update(is_default: true)
    end
  end

  def get_default_card
    @card = @current_user.card_infos&.default_card.take
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
    @card = CardInfo.find_by(id: payment_params[:id])
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
  def create_user_subscription(subscription)
    @current_user.build_subscription(current_period_end: subscription.current_period_end,
                                      current_period_start: subscription.current_period_start,
                                      interval_count:subscription.interval_count,interval: subscription.interval)
  end

  def payment_params
    params.require(:payment).permit(:token, :name, :id, :country)
  end
end
