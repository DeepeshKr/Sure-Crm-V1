json.array!(@app_user_satisfaction_levels) do |app_user_satisfaction_level|
  json.extract! app_user_satisfaction_level, :id, :name, :priority_no, :description
  json.url app_user_satisfaction_level_url(app_user_satisfaction_level, format: :json)
end
