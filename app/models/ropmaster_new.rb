class  ROPMASTER_NEW < ActiveRecord::Base
  	if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  self.table_name = 'ROPMASTER_NEW' 

  def totalcost
    if self.present?
  	(self.vc1 ||=0) + (self.pc1 ||= 0) + (self.tc1 ||= 0) 
    + (self.pack1 ||= 0) 
    + (self.copret ||= 0) +  (self.royalty ||= 0) 
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

# PROD  VARCHAR2(6 BYTE)  Yes   1
# PC1 NUMBER(5,0) Yes   2
# PC2 NUMBER(5,0) Yes   3
# PC3 NUMBER(5,0) Yes   4
# BP1 NUMBER(5,0) Yes   5
# BP2 NUMBER(5,0) Yes   6
# BP3 NUMBER(5,0) Yes   7
# SH1 NUMBER(5,0) Yes   8
# SH2 NUMBER(5,0) Yes   9
# SH3 NUMBER(5,0) Yes   10
# VC1 NUMBER(5,0) Yes   11
# VC2 NUMBER(5,0) Yes   12
# VC3 NUMBER(5,0) Yes   13
# WBP NUMBER(5,0) Yes   14
# WVC NUMBER(5,0) Yes   15
# TC1 NUMBER(5,0) Yes   16
# TC2 NUMBER(5,0) Yes   17
# TC3 NUMBER(5,0) Yes   18
# PCB1  NUMBER(5,0) Yes   19
# BPB1  NUMBER(5,0) Yes   20
# SHB1  NUMBER(5,0) Yes   21
# VCB1  NUMBER(5,0) Yes   22
# TCB1  NUMBER(5,0) Yes   23
# PCP1  NUMBER(5,0) Yes   24
# BPP1  NUMBER(5,0) Yes   25
# SHP1  NUMBER(5,0) Yes   26
# VCP1  NUMBER(5,0) Yes   27
# TCP1  NUMBER(5,0) Yes   28
# PCM1  NUMBER(5,0) Yes   29
# BPM1  NUMBER(5,0) Yes   30
# SHM1  NUMBER(5,0) Yes   31
# VCM1  NUMBER(5,0) Yes   32
# TCM1  NUMBER(5,0) Yes   33
# DNBASIC NUMBER(5,0) Yes   34
# PACK1 NUMBER(5,0) Yes   35
# PACK2 NUMBER(5,0) Yes   36
# PACK3 NUMBER(5,0) Yes   37
# WPC NUMBER(5,0) Yes   38
