class AddConstraintsOnOrders < ActiveRecord::Migration
  def up
    execute <<-EOS
      ALTER TABLE "orders" ADD CONSTRAINT orders_id_present_check CHECK ( "id" ~ '[^\\s　]' );
      ALTER TABLE "orders" ADD CONSTRAINT orders_total_check      CHECK ( "total" >= 0 );
    EOS
  end

  def down
    execute <<-EOS
      ALTER TABLE "orders" DROP CONSTRAINT orders_total_check;
      ALTER TABLE "orders" DROP CONSTRAINT orders_id_present_check;
    EOS
  end
end
