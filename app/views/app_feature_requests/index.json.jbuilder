json.array!(@app_feature_requests) do |app_feature_request|
  json.extract! app_feature_request, :id, :name, :app_id, :app_feature_type_id, :problem_this_solves, :mandatory_requirements, :technical_notes, :request_by, :require_by_date, :estimated_completion_date, :actual_completion_date, :user_approved_date, :user_satisfaction_level_id, :velocity_id, :current_status_id, :priority_id, :assigned_to, :extra_notes, :tables_used, :estimated_hours, :actual_hours, :bug_count, :linked_app_feature_id, :queue_no, :comment_count
  json.url app_feature_request_url(app_feature_request, format: :json)
end
