class OrdersByDateWorker
  include Sidekiq::Worker

  def perform(date)
    OrderMailer.report_orders_by_date(date.to_date).deliver
  end
end
