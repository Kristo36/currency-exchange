require 'rails_helper'

RSpec.describe Exchange, type: :model do
  before :each do
    @exchange = Exchange.new(base: '',
                             target: '',
                             amount: '',
                             weeks: '')
  end

  it 'validate' do
    expect(@exchange.valid?).to be_falsey
    expect(@exchange.errors.full_messages.first).to eq("can't be blank")

    @exchange.base = 'USD'
    expect(@exchange.valid?).to be_falsey
    expect(@exchange.errors.full_messages.first).to eq("Target can't be blank")

    @exchange.target = 'EUR'
    expect(@exchange.valid?).to be_falsey
    expect(@exchange.errors.full_messages.first).to eq("Amount is not a number")

    @exchange.amount = -10
    expect(@exchange.valid?).to be_falsey
    expect(@exchange.errors.full_messages.first).to eq("Amount must be greater than 0")

    @exchange.amount = 10_000
    expect(@exchange.valid?).to be_falsey
    expect(@exchange.errors.full_messages.first).to eq("Weeks is not included in the list")

    @exchange.weeks = 26
    expect(@exchange.valid?).to be_falsey
    expect(@exchange.errors.full_messages.first).to eq("Weeks must be less than 26")

    @exchange.weeks = 15
    expect(@exchange.valid?).to be_truthy
  end
end