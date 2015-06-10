class InteractionTranscript < ActiveRecord::Base
    belongs_to :interaction_master, foreign_key: "interactionid"
    belongs_to :interaction_user, foreign_key: "interactionuserid"
    belongs_to :employee, foreign_key: "employee_id"
end
