require 'rails_helper'

RSpec.describe ExchangesHelper, type: :helper do
  describe 'Exchange helper' do
    before(:each) do
      @exchange = create(:exchange)
    end

    it 'should generate api url' do

      helper.week_query('2017-10-10').should
      eql('http://api.fixer.io/2017-10-10?base=USD&symbols=EUR')
    end
  end
end