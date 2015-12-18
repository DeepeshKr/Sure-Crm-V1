class DistributorMissedOrderType < ActiveRecord::Base
  	has_many :distributor_missed_order, foreign_key: "missed_type_id"
end
