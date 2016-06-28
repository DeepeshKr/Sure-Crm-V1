class CampaignPlayListStatus < ActiveRecord::Base
	has_many :campaign_playlist, foreign_key: "list_status_id"
end
