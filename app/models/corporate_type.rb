class CorporateType < ActiveRecord::Base
	has_many :corporate, foreign_key: "active"

	def no_of_corporates
		return	Corporate.where(corporate_type_id: self.id).count
	end
end
