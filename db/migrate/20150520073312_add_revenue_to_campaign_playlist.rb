class AddRevenueToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :total_revenue, :decimal
  end
end
