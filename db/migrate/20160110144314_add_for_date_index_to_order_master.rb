class AddForDateIndexToOrderMaster < ActiveRecord::Migration
  def change
    add_index :order_masters, :orderdate
    add_index :order_masters, :order_status_master_id
    add_index :order_masters, :campaign_playlist_id
    add_index :order_masters, :customer_id
    add_index :order_masters, :employee_id
    add_index :order_masters, :media_id
    add_index :order_masters, :order_source_id
  end
end
