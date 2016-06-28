json.array!(@app_comment_display_levels) do |app_comment_display_level|
  json.extract! app_comment_display_level, :id, :name, :priority_no, :description
  json.url app_comment_display_level_url(app_comment_display_level, format: :json)
end
