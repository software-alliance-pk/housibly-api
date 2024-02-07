json.array! @subscriptions do |subscription|
  json.cancel_by_user subscription.cancel_by_user
  json.current_period_end subscription.current_period_end.to_datetime.strftime("%B %d,%Y")
  json.current_period_start subscription.current_period_start.to_datetime.strftime("%B %d,%Y")
  json.plan_title subscription.plan_title
  json.interval_count subscription.interval_count
  json.interval subscription.interval
  json.subscription_title subscription.subscription_title
  json.status subscription.status
  json.price subscription.price
  json.payment_nature subscription.payment_nature
  json.payment_currency subscription.payment_currency
  json.sub_type subscription.sub_type
  json.subscription_id subscription.subscription_id
end
