class Campaign < ActiveRecord::Base
  belongs_to :medium, foreign_key: "mediumid"
  belongs_to :campaign_stage, foreign_key: "campaignstageid"
  has_many :campaign_playlist, foreign_key: "campaignid"
  
   
  validates :name, length: { maximum: 500 }
  validates_presence_of :description
  validates_presence_of :startdate, :enddate


  def sales 
  	campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
      OrderMaster.where({campaign_playlist_id: campaignlist}).sum(:total) || 0
  end
  
  def detailed_info
    self.name << " between " << self.startdate.strftime("%d-%m-%Y") << " and " << self.enddate.strftime("%d-%m-%Y") << " on " << self.medium.name 
  end

  def productrevenue 
    campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
   orderrevenue =  OrderMaster.where({campaign_playlist_id: campaignlist})
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
    campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
    ordercost =  OrderMaster.where({campaign_playlist_id: campaignlist})

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

  def days
    (self.enddate - self.startdate).to_i
  end
  
end
