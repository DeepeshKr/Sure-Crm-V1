json.array!(@app_feature_comments) do |app_feature_comment|
  json.extract! app_feature_comment, :id, :details, :app_feature_request_id, :comments_by_id, :comment_type_id, :display_level_id
  json.url app_feature_comment_url(app_feature_comment, format: :json)
end
