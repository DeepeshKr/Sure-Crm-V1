class CreateIndiaCityLists < ActiveRecord::Migration
  def change
    create_table :india_city_lists do |t|
      t.string :name
      t.string :state

      t.timestamps null: false
    end
  end
end
