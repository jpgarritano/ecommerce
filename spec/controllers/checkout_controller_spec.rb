require 'rails_helper'

RSpec.describe CheckoutController, :type => :controller do

  describe "GET #checkout:post" do
    it "returns http success" do
      get :checkout:post
      expect(response).to have_http_status(:success)
    end
  end

end
