class  ROPUPSPROD < ActiveRecord::Base
  	if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  self.table_name = 'ROPUPSPROD' 

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
# PROD  VARCHAR2(6 BYTE)  Yes   1 
# COST  NUMBER(5,0) Yes   2 
# COMM  NUMBER(4,0) Yes   3 
# SP  NUMBER(4,0) Yes   4 
# POSTAGE NUMBER(4,0) Yes   5 
# SHIP  NUMBER(4,0) Yes   6 
end
