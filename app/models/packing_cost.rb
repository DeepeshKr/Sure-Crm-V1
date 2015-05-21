class PackingCost < ActiveRecord::Base
	establish_connection "#{Rails.env}_tlbrndu1"
  	#connect_to = Rails.env+"_tuview"
 	#establish_connection :Rails.env+"_tuview"
  	self.table_name = 'PackingCost'
end
