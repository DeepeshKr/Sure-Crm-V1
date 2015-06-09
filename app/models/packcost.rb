class PACKCOST < ActiveRecord::Base
		if Rails.env == "development"
    	establish_connection :development_tlbrndu1
  	elsif Rails.env == "production"
    	establish_connection :production_tlbrndu1
  	end
	
  	#connect_to = Rails.env+"_tuview"
 	#establish_connection :Rails.env+"_tuview"
  	self.table_name = 'PACKCOST'
end
