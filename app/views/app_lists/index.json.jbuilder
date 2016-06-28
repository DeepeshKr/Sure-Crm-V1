json.array!(@app_lists) do |app_list|
  json.extract! app_list, :id, :name, :priority_no, :primary_goal_of_app, :description, :version, :location
  json.url app_list_url(app_list, format: :json)
end
