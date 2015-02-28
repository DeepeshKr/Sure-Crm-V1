class  ROPMASTER_NEW < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'ROPMASTER_NEW' 

  def totalcost
  	(self.vc1 ||=0) + (self.pc1 ||= 0) + (self.tc1 ||= 0) + (self.pack1 ||= 0) + (self.copret ||= 0) +  (self.royalty ||= 0) 
  end

  def totalrevenue
	(self.bp1 ||= 0) +  (self.sh1 ||= 0) 
  end

end


