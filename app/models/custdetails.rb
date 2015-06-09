class  CUSTDETAILS < ActiveRecord::Base
		if Rails.env == "development"
    	establish_connection :development_cccrm
  	elsif Rails.env == "production"
    	establish_connection :production_cccrm
  	end
  #establish_connection "#{Rails.env}_cccrm"
  self.table_name = 'CUSTDETAILS' 
end