# Exchanges helper
module ExchangesHelper

  API_URL = 'http://api.fixer.io/'.freeze

  def get_rates

    exchange = []
    currency_rates = []
    beginning_of_week = Date.today.beginning_of_week

    @exchange.weeks.times do |week|
      @currency_quote = CurrencyQuote.find_by(base: @exchange.base,
                                              target: @exchange.target,
                                              date: beginning_of_week)

      if @currency_quote
      else
        api_data = HTTParty.get week_query(beginning_of_week)
        @currency_quote = CurrencyQuote.new(base: @exchange.base,
                                            target: @exchange.target,
                                            date: beginning_of_week,
                                            rate: api_data['rates'][@exchange.target])
        @currency_quote.save
      end

      exchange << { year: beginning_of_week.year,
                    week: beginning_of_week.cweek,
                    base: @exchange.base,
                    target: @exchange.target,
                    rate: @currency_quote.rate.to_f,
                    amount: @exchange.amount.to_f * @currency_quote.rate.to_f }

      currency_rates << @currency_quote.rate.to_f

      beginning_of_week -= 7
    end

    calculate_rate_average(exchange)
    calculate_profits(exchange)

    exchange
  end

  def week_query(date)
    API_URL + date.to_s + '?' + { base: @exchange.base,
                                  symbols: @exchange.target }.to_query
  end

  def calculate_rate_average(exchange_data)
    all_rates = []
    exchange_data.each do |element|
      all_rates << element[:rate]
    end

    avg_rate = all_rates.inject { |sum, el| sum + el }.to_f / all_rates.size

    @exchange.avg_rate = avg_rate
  end

  def calculate_profits(exchange_data)
    exchange_data.each do |element|
      element[:profit] = (@exchange.amount.to_f * element[:rate].to_f -
          @exchange.amount.to_f * @exchange.avg_rate.to_f).round(2)
    end
  end

  def sort_by_profit(exchange_data)
    exchange_data.sort { |a, b| b[:profit] <=> a[:profit] }
  end

end
