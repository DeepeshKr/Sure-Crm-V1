class AddFramesToCampaignPlaylists < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :frames, :integer
  end
end
