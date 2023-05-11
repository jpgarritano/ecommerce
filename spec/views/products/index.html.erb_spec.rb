require 'rails_helper'

RSpec.describe "products/index", :type => :view do
  before(:each) do
    assign(:products, [
      Product.create!(
        :type => "Type",
        :title => "Title",
        :description => "MyText",
        :type => "Type",
        :stock => 2,
        :user => nil
      ),
      Product.create!(
        :type => "Type",
        :title => "Title",
        :description => "MyText",
        :type => "Type",
        :stock => 2,
        :user => nil
      )
    ])
  end

  it "renders a list of products" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
