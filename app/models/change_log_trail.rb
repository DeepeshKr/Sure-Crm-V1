class ChangeLogTrail < ActiveRecord::Base
	belongs_to :change_log_type, foreign_key: "changelogtype_id"
end
