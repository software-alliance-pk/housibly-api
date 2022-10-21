class Api::V1::PaymentsController < Api::V1::ApiController
  Stripe.api_key = 'sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h'
  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :set_default_card]

  def create
    customer = check_customer_at_stripe
    stripe_token = payment_params[:token]
    card_name =  payment_params[:name]
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
     render json: {package: @packages},status: :ok
    end
  end

  def create_subscription
    if @current_user.card_infos.present? && @package.present?
      subscription = StripeService.create_subscription(@current_user.stripe_customer_id,params[:price_id])
      if  subscription.present?
        package = @current_user.
          build_subscription(
            payment_currency: subscription&.currency,
            current_period_end: Time.at(subscription&.current_period_end),
            subscription_id:subscription&.id,
            status: subscription&.status,
            interval_count: subscription&.plan.interval_count,
            current_period_start:Time.at(subscription&.current_period_start),
            price: subscription&.items&.data.first.plan.amount,
            interval: subscription&.plan&.interval,
            payment_nature: subscription.items.list.data.last.price.type,
            plan_title: "#{subscription&.plan.interval_count} #{subscription.plan.interval}".upcase,
            subscription_title:"#{subscription&.plan.interval_count} #{subscription.plan.interval}".upcase,
            package_type: @package.name
          )
        if package.save
          render json: {package: package},status: :ok
        else
          render json: {message: "Something went wrong contact with developer"}, status: :unprocessable_entity
        end
      else
        render json: {message: "Unable to subscribe the package"}, status: :unprocessable_entity
      end
    else
      render json: {message: "Please Add the Card first"}, status: :unprocessable_entity
    end
  end
  def get_subscription
    subscriptions = Subscription.all
    if subscriptions.present?
      render json: {subscription: subscriptions},status: :ok
    else
     render json: {package: "No Subscription Available"},status: :ok
    end
  end
  def get_sub_history
    subscriptions = @current_user.subscription
    if subscriptions.present?
      render json: {subscription: subscriptions},status: :ok
    else
     render json: {subscription: "false"},status: :ok
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
    end
  end

  def get_all_cards
    @cards = @current_user.card_infos
    if @cards.present?
      @cards
    end
  end

  def destroy_card
    if @card.present?
      @card.destroy
      user_cards_info = @current_user.card_infos
      find_first_card = user_cards_info&.first unless user_cards_info.pluck(:is_default).include?(true)
      if find_first_card
        find_first_card.update(is_default: true)
      end
      render json: { message: "Card deleted successfully!" }, status: 200
    else
      render json: { message: "Such card does not exists" }, status: 200
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
      SetDefaultCardJob.perform_now(@current_user.id,@card.card_id)
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
    if payment_params[:id].present?
      @card = CardInfo.find_by(id: payment_params[:id])
      if @card
        @card
      else
        render json: { message: "No such card exists" }, status: :ok
      end
    else
      render json: { message: "Payment id parameter is missing" }, status: :ok
    end
  end

  def find_package
    @package = Package.find_by(id: params[:package_id])
    if @package
      @package
    else
      render json: { message: "subscription not done" }, status: :ok
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
