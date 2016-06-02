class CreateCampaignPlaylistToProducts < ActiveRecord::Migration
  def change
    create_table :campaign_playlist_to_products do |t|
      t.string :name
      t.integer :campaign_playlist_id
      t.integer :product_variant_id
      
      t.timestamps null: false
    end
  end
end
