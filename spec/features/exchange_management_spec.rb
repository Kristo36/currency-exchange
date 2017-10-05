require 'rails_helper'

RSpec.feature 'Exchange management', type: :feature do
  before :each do
    @exchanges_controller = ExchangesController.new
  end

  scenario 'New user creates exchange' do
    password = 'testing'
    new_user = create(:user, password: password, password_confirmation: password)

    visit new_exchange_path

    within '#new_user' do
      fill_in 'user_email', with: new_user.email
      fill_in 'user_password', with: password
    end

    click_button 'Sign in'

    within '#new_exchange' do
      select 'EUR', from: 'exchange_base'
      select 'USD', from: 'exchange_target'
      fill_in 'exchange_amount', with: 100
      fill_in 'exchange_weeks', with: 10
    end

    allow(@exchanges_controller).to receive(:redirect_to)

    click_link_or_button 'Calculate'

    expect(Exchange.count).to eq(1)
    expect(Exchange.first.base).to eq('EUR')
  end
end
