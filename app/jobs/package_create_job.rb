class PackageCreateJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    if args.present?
      payload = PackageCreateJob.convert_object_to_h(args)
      @package = Package.find_by(stripe_package_id: payload.id)
      if @package.present?
        @package.update(name: payload.name)
      else
        Package.create(name: payload.name,stripe_package_id: payload.id ,stripe_price_id:"",price:"")
      end
    end
  end

  def self.convert_object_to_h(args)
    args.last.data.object
  end
end