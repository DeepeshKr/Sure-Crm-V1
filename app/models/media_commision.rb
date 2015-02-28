class MediaCommision < ActiveRecord::Base
	has_many :medium, foreign_key: "media_commision_id"
end
