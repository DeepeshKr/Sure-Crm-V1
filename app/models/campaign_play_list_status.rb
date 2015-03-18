class CampaignPlayListStatus < ActiveRecord::Base
	has_many :campaign_play_list, foreign_key: "list_status_id"
end
