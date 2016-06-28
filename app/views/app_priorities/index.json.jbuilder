json.array!(@app_priorities) do |app_priority|
  json.extract! app_priority, :id, :name, :priority_no, :description
  json.url app_priority_url(app_priority, format: :json)
end
