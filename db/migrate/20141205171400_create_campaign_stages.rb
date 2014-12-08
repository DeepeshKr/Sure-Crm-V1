class CreateCampaignStages < ActiveRecord::Migration
  def change
    create_table :campaign_stages do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
