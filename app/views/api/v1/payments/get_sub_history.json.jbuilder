json.cancel_by_user @subscriptions.cancel_by_user
json.current_period_end @subscriptions.current_period_end.to_datetime.strftime("%B %d,%Y")
json.current_period_start @subscriptions.current_period_start.to_datetime.strftime("%B %d,%Y")
json.plan_title @subscriptions.plan_title
json.interval_count @subscriptions.interval_count
json.interval @subscriptions.interval
json.subscription_title @subscriptions.subscription_title
json.status @subscriptions.status
json.price @subscriptions.price
json.payment_nature @subscriptions.payment_nature
json.payment_currency @subscriptions.payment_currency
json.sub_type @subscriptions.sub_type
json.subscription_id @subscriptions.subscription_id