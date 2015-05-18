class  VPP < ActiveRecord::Base
  	establish_connection "#{Rails.env}_tuview"
  	#connect_to = Rails.env+"_tuview"
 	#establish_connection :Rails.env+"_tuview"
  	self.table_name = 'VPP' 
end