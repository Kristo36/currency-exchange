# Exchanges helper
module ExchangesHelper
  API_URL = 'http://api.fixer.io/'.freeze

  def create_exchanges
    exchange = {}
    beginning_of_week = Date.today.beginning_of_week
    forecast_week = Date.today.beginning_of_week

    @exchange.weeks.times do |week|
      @currency_quote = CurrencyQuote.search_existing(@exchange.base,
                                                      @exchange.target,
                                                      beginning_of_week)

      request_quote(beginning_of_week) unless @currency_quote

      exchange[week] = { year: forecast_week.year,
                         week: forecast_week.cweek,
                         base: @exchange.base,
                         target: @exchange.target,
                         rate: @currency_quote.rate.to_f,
                         amount: (@exchange.amount.to_f *
                                  @currency_quote.rate.to_f).round(2) }

      beginning_of_week -= 7
      forecast_week += 7
    end

    calculate_rate_average(exchange)
    calculate_profits(exchange)
    rank_by_profit(exchange)

    exchange
  end

  def request_quote(beginning_of_week)
    api_data = HTTParty.get week_query(beginning_of_week)
    @currency_quote = CurrencyQuote.new(base: @exchange.base,
                                        target: @exchange.target,
                                        date: beginning_of_week,
                                        rate: api_data['rates'][@exchange.target])
    @currency_quote.save
  end

  def week_query(date)
    API_URL + date.to_s + '?' + { base: @exchange.base,
                                  symbols: @exchange.target }.to_query
  end

  def calculate_rate_average(exchange_data)
    all_rates = []
    exchange_data.each_value do |exchange|
      all_rates << exchange[:rate]
    end

    avg_rate = all_rates.inject { |sum, el| sum + el }.to_f / all_rates.size

    @exchange.avg_rate = avg_rate
  end

  def calculate_profits(exchange_data)
    exchange_data.each_value do |exchange|
      exchange[:profit] = (@exchange.amount.to_f * exchange[:rate].to_f -
          @exchange.amount.to_f * @exchange.avg_rate.to_f).round(2)
    end
  end

  def rank_by_profit(exchange_data)
    sorted_weeks = exchange_data.sort_by { |_k, v| v[:profit] }.reverse

    top_ranks = [3, sorted_weeks.count].min
    top_ranks.times do |rank|
      exchange_data[sorted_weeks[rank][0]][:rank] = rank + 1
    end
  end
end
