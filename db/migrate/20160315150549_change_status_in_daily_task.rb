class ChangeStatusInDailyTask < ActiveRecord::Migration
  def change
     change_column :daily_tasks, :status, :string
  end
end
