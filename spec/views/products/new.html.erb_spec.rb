require 'rails_helper'

RSpec.describe "products/new", :type => :view do
  before(:each) do
    assign(:product, Product.new(
      :type => "",
      :title => "MyString",
      :description => "MyText",
      :type => "",
      :stock => 1,
      :user => nil
    ))
  end

  it "renders new product form" do
    render

    assert_select "form[action=?][method=?]", products_path, "post" do

      assert_select "input#product_type[name=?]", "product[type]"

      assert_select "input#product_title[name=?]", "product[title]"

      assert_select "textarea#product_description[name=?]", "product[description]"

      assert_select "input#product_type[name=?]", "product[type]"

      assert_select "input#product_stock[name=?]", "product[stock]"

      assert_select "input#product_user[name=?]", "product[user]"
    end
  end
end
