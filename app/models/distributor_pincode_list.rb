class DistributorPincodeList < ActiveRecord::Base
	belongs_to :corporate, foreign_key: "corporate_id"
end
