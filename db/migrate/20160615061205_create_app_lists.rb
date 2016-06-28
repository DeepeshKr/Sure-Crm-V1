class CreateAppLists < ActiveRecord::Migration
  def change
    create_table :app_lists do |t|
      t.string :name
      t.integer :priority_no
      t.text :primary_goal_of_app
      t.text :description
      t.string :version
      t.string :location

      t.timestamps null: false
    end
  end
end
