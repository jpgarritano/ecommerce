# encoding: UTF-8
class OrderMailer < ActionMailer::Base
  default from: 'from@example.com'

  def first_product_purchase(order)
    @order = order
    @creator = order.product.user
    @copy_to = User.where('id <> ?', @creator.id).pluck(:email)

    mail(to: @creator.email, cc: @copy_to, subject: 'First Product Purchase')
  end

  def report_orders_by_date(date)
    @date = date
    @to = User.pluck(:email)
    report = ReportByDate.new(date)
    report.call
    unless report.result.empty?
      filepath_report = report.to_csv
      attachments["reporte_#{date.strftime('%Y-%m-%d')}.csv"] = File.read(filepath_report)
    end
    mail(to: @to, subject: "Report #{I18n.l date}")
  end
end
