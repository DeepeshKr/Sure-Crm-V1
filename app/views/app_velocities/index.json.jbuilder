json.array!(@app_velocities) do |app_velocity|
  json.extract! app_velocity, :id, :name, :priority_no, :description
  json.url app_velocity_url(app_velocity, format: :json)
end
