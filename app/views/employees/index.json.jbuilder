json.array!(@employees) do |employee|
  json.extract! employee, :id, :title, :first_name, :last_name, :employeecode, :designation, :mobile, :emailid, :location, :employment_type_id, :employee_role_id, :reporting_to_id, :enablelogin, :description
  json.url employee_url(employee, format: :json)
end
