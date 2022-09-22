class PackageCreateJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    if args.present?
      payload =  args.last[:data]
      payload = PackageCreateJob.convert_object_to_h(payload)
      unless check_data_is_live(payload)
        data = parse_data(payload)
        Package.create(name: data["name"],stripe_package_id:data["stripe_package_id"] ,stripe_price_id: "",price:"")
      else
        puts "Data is not live"
      end
    end
  end

  def self.convert_object_to_h(data)
     data.to_h
  end

  def self.check_data_is_live(payload)
    data = payload.fetch(:object)
    data[:live_mode]
  end

  def self.parse_data(payload)
    return_data = {}
    data = payload.fetch(:object)
    return_data.store("livemode",data[:livemode])
    return_data.store("name",data[:name])
    return_data.store("statement_descriptor",data[:statement_descriptor])
    return_data.store("stripe_package_id",data[:id])
    return_data
  end
end