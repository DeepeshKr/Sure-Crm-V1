class CreateCampaignPlaylists < ActiveRecord::Migration
  def change
    create_table :campaign_playlists do |t|
      t.string :name
      t.integer :campaignid
      t.time :starttime
      t.time :endtime
      t.integer :productvariantid
      t.string :filename
      t.text :description
      t.float :cost
      t.timestamps
    end
  end
end
