class AddToFrameToCampaignPlayList < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :start_frame, :integer
    add_column :campaign_playlists, :end_frame, :integer
  end
end
