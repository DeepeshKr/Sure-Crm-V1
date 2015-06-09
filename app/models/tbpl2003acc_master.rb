class  Tbpl2003acc_Master < ActiveRecord::Base
	if Rails.env == "development"
    	establish_connection :development_tlbrndu1
  	elsif Rails.env == "production"
    	establish_connection :production_tlbrndu1
  	end
  	#establish_connection "#{Rails.env}_tuview"
  	#connect_to = Rails.env+"_tuview"
 	#establish_connection :Rails.env+"_tuview"
  	self.table_name =  'TBPL2003ACC_MASTER' #"Tbpl2003acc_Master" #
end