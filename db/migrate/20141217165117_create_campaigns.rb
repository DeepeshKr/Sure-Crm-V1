class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.date :startdate
      t.date :enddate
      t.integer :mediumid
      t.text :description
      t.float :cost
      t.timestamps
    end
  end
end
