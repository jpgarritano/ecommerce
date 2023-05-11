require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:user) { create(:user) }

  describe 'GET /products' do
    context 'without JWT auth' do
      it 'returns unauthorized' do
        get products_path, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with JWT auth' do
      it 'returns ok' do
        get products_path, { format: :json }, logged_user_token(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
