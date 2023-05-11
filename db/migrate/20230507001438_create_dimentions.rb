class CreateDimentions < ActiveRecord::Migration
  def change
    create_table :dimentions do |t|
      t.float :height
      t.float :weight
      t.float :width
      t.references :product

      t.timestamps
    end
    add_index :dimentions, :product_id
  end
end
