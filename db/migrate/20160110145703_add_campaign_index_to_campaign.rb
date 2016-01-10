class AddCampaignIndexToCampaign < ActiveRecord::Migration
  def change
    add_index :campaigns, :mediumid
    add_index :campaigns, :startdate
  end
end
