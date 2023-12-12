class CustomerSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :tier,
             :tier_start_date,
             :spent,
             :spend_to_reach_next_tier,
             :downgrade_tier,
             :downgrade_date,
             :spend_to_avoid_downgrade

  def tier
    object.tier.name
  end

  def downgrade_tier
    object.downgrade_tier.try(:name)
  end

end
