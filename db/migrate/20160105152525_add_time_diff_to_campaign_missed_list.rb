class AddTimeDiffToCampaignMissedList < ActiveRecord::Migration
  def change
    add_column :campaign_missed_lists, :time_diff, :float
    add_column :campaign_missed_lists, :order_time, :datetime
    add_column :campaign_missed_lists, :play_list_time, :datetime
  end
end
