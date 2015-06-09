class PURCHASES_NEW < ActiveRecord::Base
 	if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  self.table_name = 'PURCHASES_NEW' 
#PURCHASE
#purchases_new
end