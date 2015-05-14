class MediaTape < ActiveRecord::Base
#CAMPAIGN_PLAYLIST => TAPE_ID

validates :name, :release_date, :duration_secs, presence: true
validates_uniqueness_of :name, { case_sensitive: false }
validates_uniqueness_of :tape_ext_ref_id, :scope => :media_id, message: "You cannot have the same tape id for same channel"

#validates_uniqueness_of :tape_ext_ref_id, numericality: true, allow_blank: true


#belongs to product variant, medium, 
belongs_to :product_variant, foreign_key: "product_variant_id"
belongs_to :medium, foreign_key: "media_id"


belongs_to :media_tape_head, foreign_key: "media_tape_head_id"

#has many campaign_playlist
has_many :campaign_playlist, foreign_key: "tape_id"
 
#rand(1 .. 50) # this generator a number between 1 to 50


# def productinfo
#      self.name + " --Basic: Rs." + (self.price.to_s ||= 'No Price') + " -- Total: Rs."  + (self.total.to_s ||= 'No Price')
#    end
end
