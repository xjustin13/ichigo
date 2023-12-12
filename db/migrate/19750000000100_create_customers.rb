class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string  :name,  :null=>false
      t.integer :spent, :default=>0, :null=>false
    end
  end
end
