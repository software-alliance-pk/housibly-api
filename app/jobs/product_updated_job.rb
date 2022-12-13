class ProductUpdatedJob < ApplicationJob
	queue_as :default
  def self.perform_now(*args)
    payload = args.last.data.object
    package =  Package.find_by(stripe_package_id:payload.id)
    if package.present?
      package.update(name: payload.name)
    end
  end

  def parse_data(payload)

  end
end