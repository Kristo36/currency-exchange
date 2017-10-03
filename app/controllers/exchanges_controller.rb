# Welcome controller
class ExchangesController < ApplicationController
  include ExchangesHelper

  def index
    @exchanges = Exchange.where(user_id: current_user.id)
    # @exchanges = Exchange.all

    # render plain: @exchanges
    render :index
  end

  def new
    @exchange = Exchange.new
  end

  def create
    @exchange = Exchange.new(exchange_params)
    @exchange.user_id = current_user.id

    if @exchange.save
      flash[:notice] = 'Currency exchange was successfully created'
      redirect_to exchange_path(@exchange)
    else
      render :new
    end
  end

  def edit
    @exchange = Exchange.find(params[:id])
  end

  def update
    @exchange = Exchange.find(params[:id])
    if @exchange.update(exchange_params)
      redirect_to exchange_path(@exchange)
    else
      render :edit
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

  def destroy
    @exchange = Exchange.find(params[:id])
    @exchange.destroy
    flash[:notice] = 'Currency exchange was successfully deleted!'

    redirect_to exchanges_path
  end

end
