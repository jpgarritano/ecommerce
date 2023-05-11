Rails 3.2 con Ruby 1.9.3

$ bundle _1.0.22_ install
$ bundle exec rake db:create db:migrate db:seed
$ rails s

Tests:
  bundle exec rake db:test:prepare
  RAILS_ENV=test bundle exec rspec spec/requests/


Usado con PostgreSQL 9
`docker run -d --name postgresql -p 5432:5432  -e POSTGRES_USERNAME=postgresql  -e POSTGRES_PASSWORD=postgresql frodenas/postgresql`

Ejecutar: `$ bundle exec rake report:by_date` para ejecutar tarea de envio de email con reporte.
O para escribir en crontab, para que se ejecute una vez al dia:
`$ whenever --update-crontab`

Configurado para usar con mailCatcher, en caso contrario configurar smtp_settings en environments/development.rb

Importar en Postman el archivo: ecommerce.postman_collection.json

Los cambios sobre productos y categorias se registran en tabla versions, junto con el usuario que hizo la modificacion por api (gema paper_trail).
