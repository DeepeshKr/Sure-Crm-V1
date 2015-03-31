class AddForDateToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :for_date, :date
  end
end
