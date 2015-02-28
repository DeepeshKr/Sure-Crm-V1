class MediaGroup < ActiveRecord::Base
	has_many :medium, foreign_key: "media_group_id"
end
