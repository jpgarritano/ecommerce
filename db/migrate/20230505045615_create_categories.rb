class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, :limit => 60
      t.references :user

      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE categories
        ADD CONSTRAINT fk_categories_users
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL
    add_index :categories, :user_id
  end
end
