class  B_BARCODEMASTER < ActiveRecord::Base
	if Rails.env == "development"
    	establish_connection :development_ccview
  	elsif Rails.env == "production"
    	establish_connection :production_ccview
  	end
  	#establish_connection "#{Rails.env}_tuview"
  	#connect_to = Rails.env+"_tuview"
 	#establish_connection :Rails.env+"_tuview"
  	self.table_name = 'B_BARCODEMASTER' 
end
