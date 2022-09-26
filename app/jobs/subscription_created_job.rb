class SubscriptionCreatedJob < ApplicationJob
	queue_as :default
  def self.perform_now(*args)
    payload = args.last.data.to_h
    data = payload.fetch(:object)
    user = User.find_by(stripe_customer_id: data.customer)
    subscription = Subscription.find_by(user_id: user.id)
    if subscription.present?
    	user.subscription.update(
        price: data.plan.amount,
        status:data.status,
        interval:data.plan.interval,
	    	interval_count: data.plan.interval_count,
        subscription_title: "#{data.plan.interval_count} #{data.plan.interval}".upcase,
        #current_period_end: DateTime.new(data&.current_period_end),
        current_period_end: Time.at(data&.current_period_end),
        current_period_start: Time.at(data&.current_period_start),
        payment_nature: data&.items.data.last.price.type,
        payment_currency: data&.currency
      )
    	return history(user,data)
    else
	    user.build_subscription(
        price: data.plan.amount,
        status:data.status,
        interval:data.plan.interval,
	    	interval_count: data.plan.interval_count,
        subscription_title: "#{data.plan.interval_count} #{data.plan.interval}".upcase,
        current_period_end: Time.at(data&.current_period_end),
        current_period_start: Time.at(data&.current_period_start),
        payment_nature: data&.items.data.last.price.type,
        payment_currency: data&.currency
        ).save
	    return history(user,data)
	end
    #parse_data = parse_data(payload)
  end

  def self.history(user,data)
  	user.subscription_histories.build(price: data.plan.amount,
      status:data.status,
      interval:data.plan.interval,
	    interval_count: data.plan.interval_count,
      subscription_title: "#{data.plan.interval_count} #{data.plan.interval}".upcase,
      current_period_end: Time.at(data&.current_period_end),
      current_period_start: Time.at(data&.current_period_start),
      payment_nature: data&.items.data.last.price.type,
      payment_currency: data&.currency).save

  end
end