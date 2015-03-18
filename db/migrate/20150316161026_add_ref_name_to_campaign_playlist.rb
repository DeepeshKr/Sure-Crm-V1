class AddRefNameToCampaignPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :ref_name, :string
    add_column :campaign_playlists, :list_status_id, :integer
  end
end
