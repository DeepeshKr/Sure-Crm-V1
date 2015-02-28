class InteractionUser < ActiveRecord::Base
	 has_many :interaction_transcript, foreign_key: "interactionuserid"
end
