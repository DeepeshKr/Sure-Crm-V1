class AddOrderToCampaignMissedList < ActiveRecord::Migration
  def change
    add_column :campaign_missed_lists, :order_id, :integer
    add_column :campaign_missed_lists, :campaign_id, :integer
    add_column :campaign_missed_lists, :campaign_playlist_id, :integer
    add_column :campaign_missed_lists, :called_no, :string
    add_column :campaign_missed_lists, :customer_state, :string
    add_column :campaign_missed_lists, :media_id, :integer
  end
end
