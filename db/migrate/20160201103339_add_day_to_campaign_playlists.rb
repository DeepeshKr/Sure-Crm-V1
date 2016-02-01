class AddDayToCampaignPlaylists < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :day, :integer
  end
end
