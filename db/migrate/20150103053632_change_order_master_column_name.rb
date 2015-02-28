class ChangeOrderMasterColumnName < ActiveRecord::Migration
  def change
    rename_column :order_masters, :orderstatusmaster_id, :order_status_master_id
    rename_column :order_masters, :campaignplaylist_id, :campaign_playlist_id
       
  end
end

