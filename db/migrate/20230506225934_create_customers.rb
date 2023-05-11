class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email, :limit => 100
      t.string :first_name, :limit => 50
      t.string :last_name, :limit => 50

      t.timestamps
    end
  end
end
