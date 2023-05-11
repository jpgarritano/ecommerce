require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  let(:user) { create(:user) }

  describe 'GET /customers' do
    context 'without JWT auth' do
      it 'returns unauthorized' do
        get customers_path, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with JWT auth' do
      it 'returns ok' do
        get customers_path, { format: :json }, logged_user_token(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
