json.array!(@app_comment_types) do |app_comment_type|
  json.extract! app_comment_type, :id, :name, :priority_no, :description
  json.url app_comment_type_url(app_comment_type, format: :json)
end
