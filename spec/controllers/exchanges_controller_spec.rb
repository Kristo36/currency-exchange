require 'rails_helper'

RSpec.describe ExchangesController, type: :controller do
  describe 'Anonymous user' do
    it 'should redirect to sign in' do
      login_with nil
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'Logged in user' do
    it 'should render new page' do
      login_with create(:user)
      get :new
      expect(response).to render_template(:new)
    end

    it 'should render index' do
      login_with create(:user)
      get :index
      expect(response).to render_template(:index)
    end
  end
end