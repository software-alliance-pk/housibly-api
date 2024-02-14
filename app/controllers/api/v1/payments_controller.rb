# frozen_string_literal: true

class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :find_card, only: [:get_card, :set_default_card, :update_card, :destroy_card]

  def create_card
    customer = check_customer_at_stripe
    stripe_card = StripeService.create_card(customer.id, payment_params[:token])
    return render json: { message: 'Card could not be created on Stripe' }, status: 422 if stripe_card.blank?

    @card = create_user_payment_card(stripe_card)
    if @card.save
      make_first_card_as_default
      render 'card'
    else
      render_error_messages(@card)
    end
  end

  def create_package
    @product = StripeService.create_product(payment_params[:package_name])
    price = StripeService.create_price(payment_params[:price], 'usd', payment_params[:recurring_interval], @product.id)
    Package.create(name: @product.name, price: price.unit_amount, stripe_package_id: @product.id, stripe_price_id: price.id)
    if @product
      render json: {package: @product, price: price}
    else
      render_error_messages(@product)
    end
  end

  def get_packages
    @packages = Package.all
    render json: @packages
  end

  def create_subscription
    begin
      package = Package.find_by(id: payment_params[:package_id])
      return render json: {message: 'This package is not available now.'}, status: :unprocessable_entity unless package.present?

      return render json: {message: 'Please add the card first'}, status: :unprocessable_entity unless @current_user.card_infos.present?

      subscription = StripeService.create_subscription(@current_user.stripe_customer_id, package.stripe_price_id)
      return render json: {message: 'Unable to subscribe to the package'}, status: :unprocessable_entity unless subscription.present?

      user_subscription = @current_user.build_subscription(
        payment_currency: subscription&.currency,
        current_period_end: Time.at(subscription&.current_period_end),
        subscription_id: subscription&.id,
        status: subscription&.status,
        interval_count: subscription&.plan.interval_count,
        current_period_start: Time.at(subscription&.current_period_start),
        price: subscription&.items&.data.first.plan.amount,
        interval: subscription&.plan&.interval,
        payment_nature: subscription.items.list.data.last.price.type,
        plan_title: "#{subscription&.plan.interval_count} #{subscription.plan.interval}".upcase,
        subscription_title: "#{subscription&.plan.interval_count} #{subscription.plan.interval}".upcase,
        sub_type: package.name
      )

      if user_subscription.save
        render json: { subscription: user_subscription }
      else
        render_error_messages(user_subscription)
      end
    rescue Exception => e
      render json: {message: e.message}, status: :unprocessable_entity
    end
  end

  def cancel_subscription
    return render json: { error: 'Please provide subscription id'}, status: 422 unless payment_params[:subscription_id].present?

    subscription = StripeService.cancel_subscription(payment_params[:subscription_id])
    if subscription.present?
      @current_user.subscription.update(status: subscription.status)
      render json: {subscription: subscription}
    end
  end

  def get_subscription
    subscription = @current_user.subscription
    if subscription.present?
      render json: { subscription: subscription }
    else
      render json: { message: 'No subscription for user' }
    end
  end

  def get_subscription_history
    @subscriptions = @current_user.subscription_histories
  end

  def get_card
    @transactions = StripeService.get_transactions(@current_user.stripe_customer_id)
  end

  def get_all_cards
    @cards = @current_user.card_infos
  end

  def get_default_card
    @card = @current_user.card_infos&.default_card.take
    if @card
      render 'card'
    else
      render json: { message: 'User has no card' }
    end
  end

  def set_default_card
    @current_user.card_infos.update_all(is_default: false) unless @card.is_default
    @card.update(is_default: true)
    SetDefaultCardJob.perform_now(@current_user.id, @card.card_id)
    render 'card'
  end

  def update_card
    if @card.update(name: payment_params[:name], country: payment_params[:country])
      render 'card'
    else
      render_error_messages(@card)
    end
  end

  def destroy_card
    if StripeService.remove_card(@current_user.stripe_customer_id, @card.card_id)
      @card.destroy
      user_cards_info = @current_user.card_infos
      first_card = user_cards_info&.first unless user_cards_info.pluck(:is_default).include?(true)
      if first_card
        first_card.update(is_default: true)
        SetDefaultCardJob.perform_now(@current_user.id, first_card.card_id)
      end
      render json: { message: 'Card deleted successfully!' }
    else
      render json: { message: 'Card could not be deleted' }
    end
  end

  def apple_pay
    # ApplePayService.apple_pay
  end

  private

    def payment_params
      params.require(:payment).permit(
        :id, :token, :name, :country, :subscription_id, :package_id, :package_name, :recurring_interval, :price
      )
    end

    def find_card
      if payment_params[:id].present?
        @card = CardInfo.find_by(id: payment_params[:id])
        unless @card
          render json: { message: 'No such card exists' }, status: :ok
        end
      else
        render json: { message: 'Card id parameter is missing' }, status: :unprocessable_entity
      end
    end

    def check_customer_at_stripe
      if @current_user.stripe_customer_id.present?
        customer = StripeService.get_customer(@current_user.stripe_customer_id)
      else
        customer = StripeService.create_customer(payment_params[:name], @current_user.email)
        @current_user.update(stripe_customer_id: customer.id) rescue nil
      end
      return customer
    end

    def make_first_card_as_default
      @current_user.card_infos.update_all(is_default: true) if @current_user.card_infos.count < 2
    end

    def create_user_payment_card(card)
      @current_user.card_infos.build(
        card_id: card.id, exp_month: card.exp_month,
        exp_year: card.exp_year, last4: card.last4,
        brand: card.brand, country: payment_params[:country],
        fingerprint: card.fingerprint, name: payment_params[:name]
      )
    end

    def create_user_subscription(subscription)
      @current_user.build_subscription(
        current_period_end: subscription.current_period_end,
        current_period_start: subscription.current_period_start,
        interval_count: subscription.interval_count,
        interval: subscription.interval
      )
    end
end
