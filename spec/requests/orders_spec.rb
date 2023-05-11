require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }
  let(:category) { create(:category, name: 'unique category') }
  let(:current_date) { Date.current }

  describe 'Get orders' do
    context 'without JWT' do
      it 'returns Unauthorized' do
        get orders_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when is JWT authenticated' do
      it 'returns OK' do
        get orders_path, nil, logged_user_token(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'Get Orders with filters' do
    context 'with no filters' do
      before { FactoryBot.create_list(:order, 5) }
      it 'returns every order' do
        get orders_path, nil, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end

    context 'with user id filter' do
      before do
        FactoryBot.create_list(:order, 5)
        # order from user
        FactoryBot.create(:order, product: create(:product, user: user))
      end
      it 'returns order from user' do
        get orders_path, { user_id: user.id }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'with customer/client id filter' do
      before do
        FactoryBot.create_list(:order, 5)
        FactoryBot.create(:order, customer: customer)
      end
      it 'returns orders from customer/client' do
        get orders_path, { customer_id: customer.id }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'with category id filter' do
      before do
        FactoryBot.create_list(:order, 5)
        FactoryBot.create(:order,
                          product: create(:product, categories: [category]))
      end
      it 'returns orders from category' do
        get orders_path, { category_id: category.id }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'with category and customer ids filter' do
      let!(:product1) { create(:product, categories: [category]) }
      before do
        FactoryBot.create(:order, customer: customer, product: product1)
      end
      it 'returns order with both category and customer' do
        params = { customer_id: customer.id, category_id: category.id }
        get orders_path, params, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end
  end

  describe 'Get orders by dates' do
    context 'with invalid date params' do
      before { FactoryBot.create_list(:order, 1) }
      it 'returns bad request' do
        get orders_path, { from: '2023-XX-aa' }, logged_user_token(user)
        expect(response).to have_http_status(:bad_request)

        get orders_path, { to: '2023-04-31' }, logged_user_token(user)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with valid date params' do
      before do
        month_ago = DateTime.current - 1.month
        FactoryBot.create_list(:order, 5, created_at: month_ago)
        create(:order, created_at: current_date)
        @current_date_string = current_date.strftime('%Y-%m-%d')
      end
      it "returns orders includes 'from'" do
        get orders_path, { from: @current_date_string }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end

      it 'returns orders from 1 month ago' do
        params = (current_date - 1.day).strftime('%Y-%m-%d')
        get orders_path, { to: params }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(5)
      end

      it 'includes orders from/to params' do
        params = { from: @current_date_string, to: @current_date_string }
        get orders_path, params, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end
  end

  describe 'Get orders count by granularity' do
    before do
      12.times do |i|
        FactoryBot.create(:order, created_at: Date.new(2023, i + 1, 1))
      end
    end
    context 'by year' do
      it 'returns all' do
        get orders_path, { granularity: 'year' }, logged_user_token(user)
        expect(JSON.parse(response.body)['2023-01-01']).to eq(12)
      end

      it 'only by year' do
        get orders_path, { granularity: 'year' }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'by month' do
      it 'returns 1 by month' do
        get orders_path, { granularity: 'month' }, logged_user_token(user)
        expect(JSON.parse(response.body)['2023-02-01']).to eq(1)
      end

      it 'returns 12 rows' do
        get orders_path, { granularity: 'month' }, logged_user_token(user)
        expect(JSON.parse(response.body).size).to eq(12)
      end
    end

    context 'by day' do
      before { create_list(:order, 2, created_at: Date.new(2023, 1, 2)) }
      it 'returns count by day' do
        get orders_path, { granularity: 'day' }, logged_user_token(user)
        expect(JSON.parse(response.body)['2023-01-02']).to eq(2)
      end

      it 'when no orders, no data' do
        params = { from: '2023-01-01', to: '2023-01-10', granularity: 'day' }
        get orders_path, params, logged_user_token(user)
        expect(JSON.parse(response.body)['2023-01-03']).to be_nil
      end
    end
  end

  describe '/most_selled_products (Most selled products)' do
    let(:category) { create(:category, name: 'category 1') }
    let(:product) { create(:product, categories: [category]) }
    let(:second_product) { create(:product, categories: [category]) }
    let(:third_product) { create(:product, categories: [category]) }

    before do
      create_list(:order, 18, product: third_product)
      create_list(:order, 25, product: product)
      create_list(:order, 15, product: second_product)
    end

    context 'when its authenticated' do
      before do
        get most_selled_products_orders_path, nil, logged_user_token(user)
        @response = JSON.parse(response.body)
      end
      it 'returs correct product' do
        expect(@response.first['product_title']).to eq(product.title)
      end

      it 'returs one product by category' do
        expect(@response).to eq([
                                  {
                                    'category_name' => 'category 1',
                                    'product_title' => product.title.to_s,
                                    'count_orders' => '25'
                                  }
                                ])
      end
    end

    context 'without JWT' do
      it 'returs unauthorized' do
        get most_selled_products_orders_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '/most_collected_products (Products that raised the most money)' do
    let!(:category1) { create(:category, name: 'Category 1') }
    let!(:product1) do
      create(:product, title: 'Product 1', categories: [category1])
    end
    let!(:product2) do
      create(:product, title: 'Product 2', categories: [category1])
    end
    let!(:product3) do
      create(:product, title: 'Product 3', categories: [category1])
    end
    let!(:order1) { create(:order, product: product1, price: 10) }
    let!(:order2) { create(:order, product: product1, price: 5) }
    let!(:order3) { create(:order, product: product2, price: 20) }
    let!(:order4) { create(:order, product: product2, price: 15) }
    let!(:order5) { create(:order, product: product2, price: 8) }
    let!(:order6) { create(:order, product: product3, price: 30) }
    let!(:order7) { create(:order, product: product3, price: 25) }

    context 'with JWT' do
      before do
        get most_collected_products_orders_path, nil, logged_user_token(user)
        @response = JSON.parse(response.body)
      end

      it 'returns a 200 response status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct data' do
        expect(@response).to eq([
                                  {
                                    'category_name' => category1.name,
                                    'product_title' => product3.title,
                                    'amount' => '55'
                                  },
                                  {
                                    'category_name' => category1.name,
                                    'product_title' => product2.title,
                                    'amount' => '43'
                                  },
                                  {
                                    'category_name' => category1.name,
                                    'product_title' => product1.title,
                                    'amount' => '15'
                                  }
                                ])
      end
    end

    context 'without JWT' do
      it 'returs unauthorized' do
        get most_collected_products_orders_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
