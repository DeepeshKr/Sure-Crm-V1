json.array!(@employee_roles) do |employee_role|
  json.extract! employee_role, :id, :name, :sortorder
  json.url employee_role_url(employee_role, format: :json)
end
