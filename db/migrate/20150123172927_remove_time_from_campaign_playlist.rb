class RemoveTimeFromCampaignPlaylist < ActiveRecord::Migration
  def change
    remove_column :campaign_playlists, :starttime, :datetime
    remove_column :campaign_playlists, :endtime, :datetime
  end
end
