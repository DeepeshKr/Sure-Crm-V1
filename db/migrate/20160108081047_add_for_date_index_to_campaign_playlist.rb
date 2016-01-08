class AddForDateIndexToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_index :campaign_playlists, :for_date
  end
end
