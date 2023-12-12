class AddTriggerForSpendingSinceLastYearOnCustomers < ActiveRecord::Migration
  def up
    execute <<-EOS
      CREATE FUNCTION customers_spent_update_trigger() RETURNS TRIGGER AS
        $$
        BEGIN
          IF TG_OP IN ('DELETE', 'UPDATE') THEN
            UPDATE "customers"
              SET "spent" = (SELECT COALESCE(SUM("total"), 0) FROM "orders" WHERE "orders"."customer_id" = "customers"."id" AND "orders"."created_at" >= date_trunc('year', now()- interval '1 year'))
            WHERE ("customers"."id" = old."customer_id");
          END IF;
          IF TG_OP IN ('INSERT', 'UPDATE') THEN
            UPDATE "customers"
              SET "spent" = (SELECT COALESCE(SUM("total"), 0) FROM "orders" WHERE "orders"."customer_id" = "customers"."id" AND "orders"."created_at" >= date_trunc('year', now()- interval '1 year'))
            WHERE ("customers"."id" = new."customer_id");
          END IF;
          RETURN NULL;
        END
        $$
        LANGUAGE plpgsql;

      CREATE TRIGGER customers_spent_update
        AFTER INSERT OR DELETE OR UPDATE OF "customer_id", "total" ON "orders"
        FOR EACH ROW EXECUTE PROCEDURE customers_spent_update_trigger();
    EOS
  end

  def down
    execute <<-EOS
      DROP TRIGGER customers_spent_update ON "orders";
      DROP FUNCTION customers_spent_update_trigger();
    EOS
  end
end
