class InteractionStatus < ActiveRecord::Base
  has_many :interaction_masters, foreign_key: "interaction_status_id"
end
