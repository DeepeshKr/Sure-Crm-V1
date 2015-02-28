class Campaign < ActiveRecord::Base
  belongs_to :medium, foreign_key: "mediumid"
  belongs_to :campaign_stage, foreign_key: "campaignstageid"
  has_many :campaign_playlist, foreign_key: "campaignid"
  
   
  validates :name, length: { maximum: 500 }
  validates_presence_of :description
  validates_presence_of :startdate, :enddate


  def sales 
  	campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
  	# @all_calllist = CampaignPlaylist.joins(:campaign)
   #         .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
   #         .where({campaignid: @campaignlist})
      OrderMaster.where({campaign_playlist_id: campaignlist}).sum(:total) || 0
  end
  

  def productrevenue 
    campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
    # @all_calllist = CampaignPlaylist.joins(:campaign)
   #         .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
   #         .where({campaignid: @campaignlist})
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
    # @all_calllist = CampaignPlaylist.joins(:campaign)
   #         .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
   #         .where({campaignid: @campaignlist})
      #OrderMaster.where({campaign_playlist_id: campaignlist}).sum(:productcost) || 0
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
    
    #return orderrevenue.sum(:total)


  end

  def days
    (self.enddate - self.startdate).to_i
  end
  
end
