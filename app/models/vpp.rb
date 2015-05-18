class  VPP < ActiveRecord::Base
  	establish_connection "#{Rails.env}_tuview"
 	#establish_connection :Rails.env_tuview
  	self.table_name = 'VPP' 
end