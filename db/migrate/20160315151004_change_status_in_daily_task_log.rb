class ChangeStatusInDailyTaskLog < ActiveRecord::Migration
  def change
     change_column :daily_task_logs, :status, :string
  end
end
