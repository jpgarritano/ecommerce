class CreateCategoryProducts < ActiveRecord::Migration
  def up
    create_table :category_products do |t|
        t.integer :product_id
        t.integer :category_id
      end
    add_index :category_products, :product_id
    add_index :category_products, :category_id
    execute <<-SQL
      ALTER TABLE category_products
        ADD CONSTRAINT fk_category_products_products
        FOREIGN KEY (product_id)
        REFERENCES products(id)
    SQL
    execute <<-SQL
      ALTER TABLE category_products
        ADD CONSTRAINT fk_category_products_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
    SQL
  end

  def down
    remove_index :category_products, :product_id
    remove_index :category_products, :category_id
    execute <<-SQL
      ALTER TABLE category_products
        DROP CONSTRAINT fk_category_products_products
    SQL
    execute <<-SQL
      ALTER TABLE category_products
        DROP CONSTRAINT fk_category_products_categories
    SQL
    drop_table :category_products
  end
end
