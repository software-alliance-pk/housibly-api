class PackagePriceUpdatedJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    if args.present?
      payload = PackagePriceUpdatedJob.convert_object_to_h(args)
      package = Package.find_by(stripe_package_id:payload.product)
      if package.present?
        package.update(price: payload.unit_amount,stripe_price_id:payload.id)
      end
    end
  end

  def self.convert_object_to_h(args)
    args.last.data.object
  end
end