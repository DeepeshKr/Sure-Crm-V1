class InteractionCategory < ActiveRecord::Base
  belongs_to :employee,  foreign_key: "employeeid"
  has_many :interaction_master, foreign_key: "interactioncategory_id"
  
  def no_of
    six_months = Date.today - 3.months #Time.zone.now
    InteractionMaster.where(interaction_category_id: self.id).where("created_at > ?",six_months).pluck(:id).count 
    #if InteractionMaster.where(interaction_category_id: self.id).present?
    
  end
end
