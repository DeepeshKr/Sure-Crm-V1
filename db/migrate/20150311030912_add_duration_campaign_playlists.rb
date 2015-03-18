class AddDurationCampaignPlaylists < ActiveRecord::Migration
  def change
  	add_column :campaign_playlists, :duration_secs, :integer
  	add_column :campaign_playlists, :tape_id, :integer
  	
  end
end
