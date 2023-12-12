class AddFkeyConstraintsOnOrders < ActiveRecord::Migration
  def up
    execute <<-EOS
      ALTER TABLE "orders" ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY ("customer_id") REFERENCES "customers"("id");
    EOS
  end

  def down
    execute <<-EOS
      ALTER TABLE "orders" DROP CONSTRAINT orders_customer_id_fkey;
    EOS
  end
end
