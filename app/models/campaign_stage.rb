class CampaignStage < ActiveRecord::Base
  has_many :campaign, foreign_key: "campaignstageid"
end
