class  DEALTRAN < ActiveRecord::Base
	if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  	#establish_connection "#{Rails.env}_tuview"
  	#connect_to = Rails.env+"_tuview"
 	#establish_connection :Rails.env+"_tuview"
  	self.table_name = 'DEALTRAN' 
    
    def order_master
     order_masters = OrderMaster.where(:external_order_no => self.custref)
     
     return nil if order_masters.blank?
     
     return order_masters.first
    end
end