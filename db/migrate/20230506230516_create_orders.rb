class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :customer
      t.references :product
      t.integer :quantity
      t.float :price
      t.timestamps
    end
    add_index :orders, :customer_id
    add_index :orders, :product_id

    execute <<-SQL
      ALTER TABLE orders
        ADD CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
    SQL

    execute <<-SQL
      ALTER TABLE orders
        ADD CONSTRAINT fk_orders_products
        FOREIGN KEY (product_id)
        REFERENCES products(id)
    SQL
  end
end
