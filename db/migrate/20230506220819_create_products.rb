class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :type
      t.string :title
      t.text :description
      t.integer :stock
      t.float :price
      t.references :user

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE products
      ADD CONSTRAINT fk_products_users
      FOREIGN KEY (user_id)
      REFERENCES users(id)
    SQL
    add_index :products, :user_id
  end
end
