class AddPlaylistGroupIdToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :playlist_group_id, :integer
  end
end
