class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, {:id=>false} do |t|
      t.string   :id,          :null=>false #primary key
      t.integer  :customer_id, :null=>false
      t.integer  :total,       :null=>false
      t.datetime :created_at,  :null=>false
    end
    execute <<-EOS
      DO
      $$
      BEGIN
        ALTER TABLE "orders" ADD PRIMARY KEY ("id");
      EXCEPTION
        WHEN invalid_table_definition THEN
          NULL;
      END
      $$
      LANGUAGE plpgsql;
    EOS
    add_index :orders, :customer_id
    add_index :orders, :created_at
  end
end
