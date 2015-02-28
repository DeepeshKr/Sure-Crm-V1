class InteractionCategory < ActiveRecord::Base
  belongs_to :employee,  foreign_key: "employeeid"
  has_many :interaction_master, foreign_key: "interactioncategory_id"
end
