json.array!(@daily_tasks) do |daily_task|
  json.extract! daily_task, :id, :sort_order, :name, :frequency, :description, :syntax, :parameters, :status, :department, :manager
  json.url daily_task_url(daily_task, format: :json)
end
