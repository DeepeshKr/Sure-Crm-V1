class AddAllIndexToFeatureRequest < ActiveRecord::Migration
  def change
    add_index :app_feature_requests, :app_feature_type_id
    add_index :app_feature_requests, :request_by
    add_index :app_feature_requests, :require_by_date
    add_index :app_feature_requests, :estimated_completion_date
    add_index :app_feature_requests, :actual_completion_date
    add_index :app_feature_requests, :user_approved_date
    add_index :app_feature_requests, :user_satisfaction_level_id
    add_index :app_feature_requests, :velocity_id
    add_index :app_feature_requests, :current_status_id
    add_index :app_feature_requests, :priority_id
  end
end
