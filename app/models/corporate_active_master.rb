class CorporateActiveMaster < ActiveRecord::Base
	has_many :corporate, foreign_key: "active"
end
