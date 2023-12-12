namespace :customer do
  desc 'SET EACH CUSTOMER SPENDING SINCE LAST YEAR'
  task(:set_spending_since_last_year=>:environment) do
    Customer.find_each{|c| c.set_spending_since_last_year!}
  end
end
