class CreateDailyTaskLogs < ActiveRecord::Migration
  def change
    create_table :daily_task_logs do |t|
      t.integer :daily_task_id
      t.string :name
      t.text :syntax_error
      t.integer :status
      t.datetime :checked_on
      t.string :checked_by

      t.timestamps null: false
    end
  end
end
