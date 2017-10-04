require 'rails_helper'

RSpec.describe ExchangesController, type: :controller do
  describe 'Anonymous user' do
    it 'redirects to sign in' do
      login_with nil
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'Logged in user' do
    it 'redirects to sign in' do
      login_with create(:user)
      get :new
      expect(response).to render_template(:new)
    end
  end
end