class ChangeLogType < ActiveRecord::Base
	has_many :change_log_trail, foreign_key: "changelogtype_id"
end
