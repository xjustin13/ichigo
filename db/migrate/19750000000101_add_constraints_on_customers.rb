class AddConstraintsOnCustomers < ActiveRecord::Migration
  def up
    execute <<-EOS
      ALTER TABLE "customers" ADD CONSTRAINT customers_name_present_check CHECK ( "name"  ~ '[^\\s　]' );
      ALTER TABLE "customers" ADD CONSTRAINT customers_spent_check        CHECK ( "spent" >= 0 );
    EOS
  end

  def down
    execute <<-EOS
      ALTER TABLE "customers" DROP CONSTRAINT customers_spent_check;
      ALTER TABLE "customers" DROP CONSTRAINT customers_name_present_check;
    EOS
  end
end
