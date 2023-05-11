require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do

  describe "GET #most_selled_products" do
    it "returns http success" do
      get :most_selled_products
      expect(response).to have_http_status(:success)
    end
  end

end
