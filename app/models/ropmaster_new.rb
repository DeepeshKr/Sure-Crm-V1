class  ROPMASTER_NEW < ActiveRecord::Base
  	if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  self.table_name = 'ROPMASTER_NEW' 

  def totalcost
    if self.present?
  	(self.vc1 ||=0) + (self.pc1 ||= 0) + (self.tc1 ||= 0) + (self.pack1 ||= 0) + (self.copret ||= 0) +  (self.royalty ||= 0) 
     else

    end
  end

  def totalrevenue
    if self.present?
      (self.bp1 ||= 0) +  (self.sh1 ||= 0) 
    else

    end
	
  end

end


