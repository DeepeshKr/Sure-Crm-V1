class Medium < ActiveRecord::Base
   has_many :campaign, foreign_key: "mediumid" , dependent: :destroy
   has_one :corporate
   has_many :campaign_playlist, through: :campaign
   has_many :order_master,  foreign_key: "media_id"
   
   belongs_to :media_commision,  foreign_key: "media_commision_id"
   belongs_to :media_group,  foreign_key: "media_group_id"
   def mediainfo
     self.name + " -- " + self.telephone + " -- "  + self.state ||= 'All States'
   end
   
end