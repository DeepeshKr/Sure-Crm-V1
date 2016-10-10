class CreateCustDetailsTrackLogs < ActiveRecord::Migration
  def change
    create_table :cust_details_track_logs do |t|
      t.belongs_to :cust_details_track, index: true
      t.integer :cust_details_track_id
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
