class CreateCampaignMissedLists < ActiveRecord::Migration
  def change
    create_table :campaign_missed_lists do |t|
      t.integer :product_list_id
      t.integer :product_variant_id
      t.integer :productmaster_id
      t.string :external_prod
      t.string :reason
      t.text :description

      t.timestamps null: false
    end
  end
end
