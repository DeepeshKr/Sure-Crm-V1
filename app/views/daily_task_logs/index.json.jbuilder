json.array!(@daily_task_logs) do |daily_task_log|
  json.extract! daily_task_log, :id, :daily_task_id, :name, :syntax_error, :status, :checked_on, :checked_by
  json.url daily_task_log_url(daily_task_log, format: :json)
end
