class AddGroupTotalCostToCampagnPlaylist < ActiveRecord::Migration
  def change
    add_column :campaign_playlists, :group_total_cost, :decimal, :precision => 12, :scale => 4
  end
end
