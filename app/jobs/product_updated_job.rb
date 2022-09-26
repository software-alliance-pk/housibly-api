class ProductUpdatedJob < ApplicationJob
	queue_as :default
  def self.perform_now(*args)
    payload = args.last.data.object
    Package.update(name: payload.name,stripe_package_id: payload.id ,stripe_price_id:"",price:"")

  end

  def parse_data(payload)

  end
end