class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :product
  attr_accessible :price, :quantity, :customer, :product

  scope :by_customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :by_category, ->(category_id) { includes(product: :categories).where(categories: { id: category_id }) }
  scope :by_user,     ->(user_id)     { includes(:product).where(products: { user_id: user_id }) }

  def self.by_date(day)
    joins(:product)
      .group(:product_id, :title)
      .where(created_at: day.beginning_of_day..day.end_of_day)
      .count
  end

  def self.count_by_granularity(granularity)
    group(granularity_query(granularity, :created_at)).count
  end

  # Alternativa a usar gema GroupDate
  def self.granularity_query(granularity, column)
    grouped_column = "#{table_name}.#{column}"
    case granularity.to_sym
    when :week
      time_zone = Time.zone.tzinfo.name
      return "(DATE_TRUNC('#{granularity}', (#{grouped_column}::timestamptz - INTERVAL '1 day' - INTERVAL '1' hour) AT TIME ZONE '#{time_zone}') + INTERVAL '1 day' + INTERVAL '1' hour) AT TIME ZONE '#{time_zone}'"
    when :day, :month, :year
      "DATE_TRUNC('#{granularity}', #{grouped_column})::date"
    end
  end
end
