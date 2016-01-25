class PRODMASTER < ActiveRecord::Base
  #establish_connection "#{Rails.env}_tuview"

  	if Rails.env == "development"
    	establish_connection :development_tlbrndu1
  	elsif Rails.env == "production"
    	establish_connection :production_tlbrndu1
  	end
  self.table_name = 'PRODMASTER'

end
