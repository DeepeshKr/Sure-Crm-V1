class CreateMediaCostMasters < ActiveRecord::Migration
  def change
    create_table :media_cost_masters do |t|
      t.string :name
      t.integer :duration_secs
      t.decimal :cost_per_sec
      t.integer :media_id
      t.integer :str_hr
      t.integer :str_min
      t.integer :str_sec
      t.integer :end_hr
      t.integer :end_min
      t.integer :end_sec
      t.text :description

      t.timestamps null: false
    end
  end
end
