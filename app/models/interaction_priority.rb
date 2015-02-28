class InteractionPriority < ActiveRecord::Base
  has_many :interaction_masters, foreign_key: "interactionpriority_id"
end
