class Customer < ActiveRecord::Base
  TIERS = JSON.parse(
    [
      {:name=>'Gold',   :minimum=>500_00},
      {:name=>'Silver', :minimum=>100_00},
      {:name=>'Bronze', :minimum=>0}
    ].to_json,
    :object_class=>OpenStruct
  )

  has_many :orders, :inverse_of=>:customer, :dependent=>:restrict

  attr_accessible :id, :name

  validates :name, :presence=>true

  # call on New Years
  def set_spending_since_last_year!
    total = self.orders.where(%["created_at" >= ?], 1.year.ago.beginning_of_year).sum(:total)
    self.update_column(:spent, total)
  end

  def tier
    TIERS.sort_by(&:minimum).reverse.find{|t| t.minimum <= self.spent}
  end

  def next_tier
    TIERS.sort_by(&:minimum).find{|t| t.minimum > self.spent}
  end

  def downgrade_tier
    dt = TIERS.sort_by(&:minimum).reverse.find{|t| t.minimum <= spent_after_this_year}
    dt unless dt == self.tier
  end

  def tier_start_date
    1.year.ago.beginning_of_year.to_date
  end

  def downgrade_date
    Time.now.end_of_year.to_date
  end

  def spend_to_reach_next_tier
    (self.next_tier.minimum - self.spent) unless self.next_tier.nil?
  end

  def progress_to_next_tier
    (self.spent / self.next_tier.minimum.to_f) unless self.next_tier.nil?
  end

  def spend_to_avoid_downgrade
    return 0 if self.downgrade_tier.nil?
    self.tier.minimum - spent_after_this_year
  end

private

  def spent_after_this_year
    @spent_after_this_year ||= self.orders.where(%["created_at" >= ?], Time.now.beginning_of_year).sum(:total)
  end

end
