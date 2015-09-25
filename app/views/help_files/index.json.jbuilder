json.array!(@help_files) do |help_file|
  json.extract! help_file, :id, :name, :link, :description, :code_used, :database_used, :tags, :employee_id
  json.url help_file_url(help_file, format: :json)
end
