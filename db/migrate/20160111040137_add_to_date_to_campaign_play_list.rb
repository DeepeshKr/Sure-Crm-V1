class AddToDateToCampaignPlayList < ActiveRecord::Migration
  def change
    add_index :campaign_playlists, :list_status_id
  end
end
