class CurrencyQuote < ApplicationRecord

  def self.search_existing(base, target, date)
    CurrencyQuote.find_by(base: base,
                          target: target,
                          date: date)
  end
end
