class AppFeatureRequest < ActiveRecord::Base
  belongs_to :employee, foreign_key: "request_by" #, class_name: "Employee"
  #belongs_to :employee, foreign_key: "assigned_to", class_name: "Working"
  belongs_to :app_list, foreign_key: "app_id"
  belongs_to :app_feature_type, foreign_key: "app_feature_type_id"
  belongs_to :user_satisfaction_level, foreign_key: "user_satisfaction_level_id"
  belongs_to :app_velocity, foreign_key: "velocity_id"
  belongs_to :app_status, foreign_key: "current_status_id"
  belongs_to :app_priority, foreign_key: "priority_id"

  belongs_to :main_feature, class_name: "AppFeatureRequest", foreign_key: "linked_app_feature_id"
  has_many :linked_feature, class_name: "AppFeatureRequest",foreign_key: "linked_app_feature_id"

  has_many :app_feature_comment, foreign_key: "app_feature_request_id"

  validates :name,  :presence => { :message => "Please give a name to this request" }
  validates :problem_this_solves,  :presence => { :message => "What problem does this solve, please explain" }
  #validates :mandatory_requirements,  :presence => { :message => "What are the mandatory requirements" }
  validates :app_feature_type_id,  :presence => { :message => "Please select type of request" }
  validates :app_id,  :presence => { :message => "Please select the app" }
  validates :request_by,  :presence => { :message => "This request is from" }
  #validates :require_by_date,  :presence => { :message => "Please give the required by date" }
  validates :priority_id,  :presence => { :message => "Please select Priority of this app" }

  def schedule
    return nil if self.require_by_date.blank?
    return nil if self.estimated_completion_date.blank?
    return "On Time in " if self.require_by_date >= self.estimated_completion_date
    return "Delayed by " if self.require_by_date < self.estimated_completion_date
  end

end
