class CampaignPlaylist < ActiveRecord::Base
  belongs_to :campaign, foreign_key: "campaignid"
  belongs_to :product_variant, foreign_key: "productvariantid"
 
 has_many :order_master, foreign_key: "campaignplaylist_id"

   
  validates :productvariantid, numericality: { only_integer: true }
  validates :campaignid, numericality: { only_integer: true }
  validates :name, length: { maximum: 500 }
  validates_presence_of :start_hr, :start_min, :start_sec, :end_hr, :end_min, :end_sec,:cost
  #validate :time_validation
  
 # validates :starttime 
 # validates :endtime
  #http://guides.rubyonrails.org/v3.2.19/active_record_querying.html#array-conditions

  def sales 
      OrderMaster.where('campaign_playlist_id = ?', self.id).sum(:total) || 0
  end

  def time_validation
      if self[:endtime] < self[:starttime]
        errors[:endtime] << "can't be in less than %d" %[starttime]
        return false
      else
        return true
      end
  end

 def starttime
 # str = ":"
     #  self.end_hr + ":" + self.end_min + ":" + self.end_sec 
     #str.concat(self.start_hr)
      self.start_hr.to_s.rjust(2, '0') << ":" << self.start_min.to_s.rjust(2, '0')  << ":" << self.start_sec.to_s.rjust(2, '0') 
    #t = (self.end_hr + ":" + self.end_min + ":" + self.end_sec)  - (self.start_hr + ":" + self.start_min + ":" + self.start_sec)
   # mm, ss = t.divmod(60)
   #  "%d m %d s" % [mm, ss]
  
  end
  def endtime
     #str = ":"
     #  self.end_hr + ":" + self.end_min + ":" + self.end_sec 
     #str.concat(self.end_hr)
      self.end_hr.to_s.rjust(2, '0') << ":" << self.end_min.to_s.rjust(2, '0') << ":" << self.end_sec.to_s.rjust(2, '0')
     # self.start_hr + ":" + self.start_min + ":" + self.start_sec
    #t = (self.end_hr + ":" + self.end_min + ":" + self.end_sec)  - (self.start_hr + ":" + self.start_min + ":" + self.start_sec)
   # mm, ss = t.divmod(60)
   #  "%d m %d s" % [mm, ss]
  
  end
  
  def playtime
   hour_min_sec(self.start_hr, self.start_min, self.start_sec, self.end_hr, self.end_min, self.end_sec)
  end

  def playlistinfo
    #self.product_variant.name + " between " + self.start_hr || 0 + ":" + self.start_min + ":" + self.start_sec + " to " + self.end_hr + ":" + self.end_min + ":" + self.end_sec + " (" + self.name + ") "
    self.product_variant.name + " between " + self.start_hr.to_s || 0 + ":"  +  " (" + self.name + ") "
  end

def productrevenue 
     orderrevenue =  OrderMaster.where(campaign_playlist_id: self.id)
    if orderrevenue.present?
        total = 0
        orderrevenue.each do |c|
          total += c.productrevenue
        end
      return total
       
    else
      return 0
    end
    
  end


  def productcost 
      ordercost =  OrderMaster.where(campaign_playlist_id: self.id)

      if ordercost.present?
        total = 0
        ordercost.each do |c|
          total += c.productcost
        end
      return total
      
      else
        return 0
      end  
  end

after_create :updatecampaign

after_save :updatecampaign

private

    def hour_min_sec(s_hr,s_min, s_sec, e_hr, e_min, e_sec)
     first = (s_hr.to_i * 60 * 60) + (s_min.to_i * 60) + s_sec.to_i
     last = (e_hr.to_i * 60 * 60) + (e_min * 60) + e_sec.to_i

    difference = last - first
    seconds    =  difference % 60
    difference = (difference - seconds) / 60
    minutes    =  difference % 60
    difference = (difference - minutes) / 60
    hours      =  difference % 24

    return hours.to_s.rjust(2, '0') << ":" << minutes.to_s.rjust(2, '0') << ":" << seconds.to_s.rjust(2, '0')

  end

    def updatecampaign
      campaign = Campaign.find(self.campaignid)
      campaign.update(cost: CampaignPlaylist.where('campaignid = ?', self.campaignid).sum(:cost))
    end

end
