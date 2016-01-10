class AddCampaignIndexToCampaignPlayList < ActiveRecord::Migration
  def change
    add_index :campaign_playlists, :campaignid
    add_index :campaign_playlists, :channeltapeid
    add_index :campaign_playlists, :productvariantid
    add_index :campaign_playlists, :playlist_group_id
    add_index :campaign_playlists, :start_hr
    add_index :campaign_playlists, :start_min
    add_index :campaign_playlists, :start_sec
    add_index :campaign_playlists, :end_hr
    add_index :campaign_playlists, :end_min
    add_index :campaign_playlists, :end_sec
  end
end
