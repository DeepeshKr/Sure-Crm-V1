json.array!(@app_feature_types) do |app_feature_type|
  json.extract! app_feature_type, :id, :name, :priority_no, :description
  json.url app_feature_type_url(app_feature_type, format: :json)
end
