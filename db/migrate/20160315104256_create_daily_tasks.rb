class CreateDailyTasks < ActiveRecord::Migration
  def change
    create_table :daily_tasks do |t|
      t.integer :sort_order
      t.string :name
      t.string :frequency
      t.text :description
      t.text :syntax
      t.text :parameters
      t.integer :status
      t.string :department
      t.string :manager

      t.timestamps null: false
    end
  end
end
