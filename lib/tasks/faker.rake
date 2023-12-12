namespace :faker do
  desc 'POPULATE DATABASE WITH SAMPLE DATA'
  task(:populate=>:environment) do
    10.times do
      c = Customer.new
      c.name = Faker::Name.unique.name
      rand(3..60).times do
        o = Order.new
        o.customer   = c
        o.id         = Faker::Code.unique.asin
        o.total      = rand(10..29_99)
        o.created_at = Faker::Time.backward(365*3)
        o.save
      end
    end
  end
end
