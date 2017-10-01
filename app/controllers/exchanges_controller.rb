# Welcome controller
class ExchangesController < ApplicationController
  include ExchangesHelper

  def new
    @exchange = Exchange.new
  end

  def create
    @exchange = Exchange.new(exchange_params)
    if @exchange.save
      redirect_to exchange_path(@exchange)
    else
      render :new
    end
  end

  def show
    @exchange = Exchange.find(params[:id])

    @exchange_calculations = get_rates

    render :show
  end

  private def exchange_params
    params.require(:exchange).permit(:base, :target, :amount, :weeks)
  end

end
