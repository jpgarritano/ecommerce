class ReportByDate < ReportsGenerator
  attr_accessor :date

  def initialize(date)
    @date = date
  end

  def call
    @result = Order.by_date(date).map do |(pid, pname), count|
      { product_id: pid, product_name: pname, count: count }
    end
  end
end
