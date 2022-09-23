class SubscriptionCreatedJob < ApplicationJob
	queue_as :default
  def self.perform_now(*args)
    payload = args.last.data.to_h
    data = payload.fetch(:object)
    user = User.find_by(stripe_customer_id: data.customer)
    subscription = Subscription.find_by(user_id: user.id)
    if subscription.present?
    	user.subscription.update(price: data.plan.amount,status:data.status,interval:data.plan.interval,
	    	interval_count: data.plan.interval_count,subscription_title: "#{data.plan.interval_count} #{data.plan.interval}".upcase)
    	return history(subscription, user,data)
    else
	    user.build_subscription.create(price: data.plan.amount,status:data.status,interval:data.plan.interval,
	    	interval_count: data.plan.interval_count,subscription_title: "#{data.plan.interval_count} #{data.plan.interval}".upcase)
	    return history(subscription, user,data)
	end
    #parse_data = parse_data(payload)
  end

  def self.history(subscription, user,data)
  	SubscriptionHistory.create(price: data.plan.amount,status:data.status,interval:data.plan.interval,
	    	interval_count: data.plan.interval_count,subscription_title: "#{data.plan.interval_count} #{data.plan.interval}".upcase)

  end
end