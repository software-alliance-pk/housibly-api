class CurrencyConversion < ApplicationRecord

  def convert(amount:, from:, to:)
    return (amount * self.rates[from]) / self.rates[to]
  end
end
