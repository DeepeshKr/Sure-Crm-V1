class CreatePageTrails < ActiveRecord::Migration
  def change
    create_table :page_trails do |t|
      t.string :name
      t.integer :order_id
      t.integer :page_id
      t.string :url
      t.string :employee_id
      t.integer :duration_secs

      t.timestamps null: false
    end
  end
end
