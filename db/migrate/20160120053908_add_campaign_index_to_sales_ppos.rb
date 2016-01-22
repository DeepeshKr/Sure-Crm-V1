class AddCampaignIndexToSalesPpos < ActiveRecord::Migration
  def change
      add_index :sales_ppos, :campaign_playlist_id
      add_index :sales_ppos, :campaign_id
      add_index :sales_ppos, :product_master_id
      add_index :sales_ppos, :product_variant_id
      add_index :sales_ppos, :product_list_id
      add_index :sales_ppos, :prod
      add_index :sales_ppos, :order_id
      add_index :sales_ppos, :order_line_id
      add_index :sales_ppos, :order_status_id
      add_index :sales_ppos, :order_last_mile_id
      add_index :sales_ppos, :media_id
      add_index :sales_ppos, :external_order_no
      add_index :sales_ppos, :order_pincode
      add_index :sales_ppos, :city
      add_index :sales_ppos, :state
  end
end
