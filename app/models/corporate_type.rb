class CorporateType < ActiveRecord::Base
	has_many :corporate, foreign_key: "active"
end
