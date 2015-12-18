class DistributorMissedOrder < ActiveRecord::Base
  	belongs_to :distributor_missed_order_type, foreign_key: "missed_type_id"
    belongs_to :corporate, foreign_key: "corporate_id"

end
