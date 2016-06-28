class CreateAppFeatureRequests < ActiveRecord::Migration
  def change
    create_table :app_feature_requests do |t|
      t.string :name
      t.integer :app_id
      t.integer :app_feature_type_id
      t.text :problem_this_solves
      t.text :mandatory_requirements
      t.text :technical_notes
      t.integer :request_by
      t.datetime :require_by_date
      t.datetime :estimated_completion_date
      t.datetime :actual_completion_date
      t.datetime :user_approved_date
      t.integer :user_satisfaction_level_id
      t.integer :velocity_id
      t.integer :current_status_id
      t.integer :priority_id
      t.integer :assigned_to
      t.text :extra_notes
      t.text :tables_used
      t.integer :estimated_hours
      t.integer :actual_hours
      t.integer :bug_count
      t.integer :linked_app_feature_id
      t.integer :queue_no
      t.integer :comment_count

      t.timestamps null: false
    end
  end
end
