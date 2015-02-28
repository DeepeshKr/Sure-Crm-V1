class AddTimeToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :start_hr, :integer
    add_column :campaign_playlists, :start_min, :integer
    add_column :campaign_playlists, :start_sec, :integer
    add_column :campaign_playlists, :end_hr, :integer
    add_column :campaign_playlists, :end_min, :integer
    add_column :campaign_playlists, :end_sec, :integer
  end
end
