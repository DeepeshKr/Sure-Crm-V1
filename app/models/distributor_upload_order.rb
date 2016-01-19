class DistributorUploadOrder < ActiveRecord::Base
  attr_accessor :switchon, :switchoff

  def switchoff
  #  self.update(online_order_id: 0, online_description: , online_last_ran_on: t)
  end
  def switchon
  #  self.update(online_order_id: 1, online_description: , online_last_ran_on: t)
  end

end
