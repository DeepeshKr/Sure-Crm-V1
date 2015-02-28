class InteractionMaster < ActiveRecord::Base
  belongs_to :interaction_category, foreign_key: "interaction_category_id"
  belongs_to :interaction_priority, foreign_key: "interaction_priority_id"
  belongs_to :interaction_status, foreign_key: "interaction_status_id"
  belongs_to :product_variant, foreign_key: "product_variant_id"
  belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
  
  belongs_to :customer, foreign_key: "customer_id" #, polymorphic: true
   
  has_many :interaction_transcript, foreign_key: "interactionid"

  validates :customer_id,  :presence => { :message => "No customer selected!" } 
  validates :interaction_category_id,  :presence => { :message => "No problem category selected!" }
  validates :interaction_priority_id,  :presence => { :message => "No problem priority selected!" }
  validates :interaction_status_id,  :presence => { :message => "No problem status selected!" }

  validates_associated :interaction_transcript

  after_create :creator

  private
  	def creator
  		self.update(createdon: Time.current.to_date, resolveby: Time.current.to_date + 10.days)
  		# CREATEDON
  		# CLOSEDON
  		# RESOLVEBY
  	end
end
