class Order < ActiveRecord::Base
  belongs_to :customer, :inverse_of=>:orders
  attr_readonly :created_at

  alias_attribute :orderId,      :id
  alias_attribute :customerId,   :customer_id
  alias_attribute :totalInCents, :total
  alias_attribute :date,         :created_at

  attr_accessor   :customerName

  attr_accessible :orderId,
                  :customerId,
                  :totalInCents,
                  :date,
                  :customerName

  # primary key
  validates :id, :presence=>true
  validates :id, :uniqueness=>{:case_sensitive=>false}, :allow_blank=>true

  validates_presence_of :customer
  validates_associated  :customer

  validates :total, :presence=>true
  validates :total, :numericality=>{:only_integer=>true, :greater_than_or_equal_to=>0}, :allow_blank=>true

  before_validation :set_new_customer, :on=>:create, :if=>"customer.nil?"

  def self.since_last_year
    self.where(%["created_at" >= ?], 1.year.ago.beginning_of_year)
  end

private

  def set_new_customer
    self.customer = Customer.new(:id=>self.customer_id, :name=>self.customerName)
  end

end
