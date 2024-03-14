class CurrencyRatesUpdateJob < ApplicationJob
  queue_as :default

  def perform
    begin
      response = Faraday.get('https://cdn.shopify.com/s/javascripts/currencies.js')
      puts "Error while fetching currency rates. Response status: #{response.status}" unless response.success?

      match = response.body.match(/(?<=rates:)\s*\{.+?\}/)
      puts "Error while extracting currency rates from response. Response: #{response}" unless match

      conversion = CurrencyConversion.first || CurrencyConversion.create
      conversion.rates = match[0].scan(/(\w+):(\d*\.?\d+[eE]?[-+]?\d*)/).map{ |val| [val[0], val[1].to_f] }.to_h
      puts "Error saving currency rates. Rates: #{conversion}" unless conversion.save
    rescue => e
      puts "Error while getting currency rates. Error message: #{e.message}"
    end
  end
end
