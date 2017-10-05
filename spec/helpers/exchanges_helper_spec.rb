require 'rails_helper'

RSpec.describe ExchangesHelper, type: :helper do
  describe 'Exchange helper' do
    before(:each) do
      @exchange = create(:exchange)

      @exchange_data = {}
      @exchange_data[0] = { year: 2017, week: 30, base: 'USD',
                            target: 'EUR', rate: 10,
                            amount: @exchange.amount.to_f * 10 }
      @exchange_data[1] = { year: 2017, week: 31, base: 'USD',
                            target: 'EUR', rate: 15,
                            amount: @exchange.amount.to_f * 15 }
      @exchange_data[2] = { year: 2017, week: 32, base: 'USD',
                            target: 'EUR', rate: 20,
                            amount: @exchange.amount.to_f * 20 }
    end

    it 'should generate api url' do
      expected_week_url = 'http://api.fixer.io/2017-10-10?base=USD&symbols=EUR'

      expect(helper.week_query('2017-10-10')).to eq(expected_week_url)
    end

    it 'should calculate average rate' do
      expect(@exchange.avg_rate).to eq(2.to_f)

      helper.calculate_rate_average(@exchange_data)
      expect(@exchange.avg_rate).to eq(15.to_f)
    end

    it 'should calculate profit compared to average' do
      helper.calculate_rate_average(@exchange_data)
      expect(@exchange.avg_rate).to eq(15.to_f)

      helper.calculate_profits(@exchange_data)
      expect(@exchange_data[0][:profit]).to eq(-500.to_f)
      expect(@exchange_data[1][:profit]).to eq(0.to_f)
      expect(@exchange_data[2][:profit]).to eq(500.to_f)
    end

    it 'should rank exchange rates by profit' do
      @exchange_data[0][:profit] = -500.to_f
      @exchange_data[1][:profit] = 0.to_f
      @exchange_data[2][:profit] = 500.to_f

      helper.rank_by_profit(@exchange_data)
      expect(@exchange_data[0][:rank]).to eql(3)
      expect(@exchange_data[1][:rank]).to eql(2)
      expect(@exchange_data[2][:rank]).to eql(1)
    end
  end
end
