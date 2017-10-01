# Welcome controller
class CurrencyQuotesController < ApplicationController
  def home
  end

  def new
    @currency_quote = CurrencyQuote.new
    @currency_quote.save
  end

  def create
  end

end
