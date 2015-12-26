class Medium < ActiveRecord::Base
   has_many :campaign, foreign_key: "mediumid" , dependent: :destroy
   has_one :corporate
   has_many :campaign_playlist, through: :campaign
   has_many :order_master,  foreign_key: "media_id"
   has_many :media_tape, foreign_key: "media_id"
   has_many :media_cost_master, foreign_key: "media_id"
   has_many :promotion, foreign_key: "media_id"

   belongs_to :media_commision,  foreign_key: "media_commision_id"
   belongs_to :media_group,  foreign_key: "media_group_id"
   belongs_to :employee,  foreign_key: "employee_id"
  # validates_numericality_of :employee_id, allow_nil: true , numericality: { only_integer: true }
   validates_numericality_of :value, allow_nil: true , numericality: { only_integer: true }, :less_than_or_equal_to => 1
   validates_numericality_of :daily_charges, numericality: { only_integer: true }, allow_nil: true
   validates_numericality_of :paid_correction, allow_nil: true , numericality: { only_integer: true }, :less_than_or_equal_to => 1

  #  after_update :recalculate_media_total_cost
  #  after_create :recalculate_media_total_cost

   def mediainfo
      if self.media_group_id.present?
          (self.media_group.name || "") + "--" + (self.name || "") + " -- " + (self.dnis || "") + " -- " + (self.telephone || "" ) + " -- " + self.state ||= 'All States'
      else
          (self.name || "") + " -- " + (self.dnis || "") + " -- " + (self.telephone || "" ) + " -- " + (self.state ||= 'All States')
      end
   end

   def recalculate_media_total_cost
     hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f

     hbn_list = MediaCostMaster.where(media_id: 11200) #.order("str_hr, str_min")
     hbn_list.each do |hbn|
      new_total = hbn_media_cost * hbn.slot_percent
      hbn.update(total_cost: new_total)
     end

   end

end
