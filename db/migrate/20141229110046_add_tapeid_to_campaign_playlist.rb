class AddTapeidToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :channeltapeid, :string
    add_column :campaign_playlists, :internaltapeid, :string
  end
end
