namespace :report do
  desc "reporte con compras realizadas de cada producto del dia anterior."
  task :by_date => :environment do
    OrdersByDateWorker.perform_async(Date.current - 1.day)
  end
end
