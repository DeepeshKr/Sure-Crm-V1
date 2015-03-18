class CreateCampaignPlayListStatuses < ActiveRecord::Migration
  def change
    create_table :campaign_play_list_statuses do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
