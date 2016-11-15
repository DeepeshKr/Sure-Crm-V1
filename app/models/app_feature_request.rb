class AppFeatureRequest < ActiveRecord::Base
  mount_uploader :user_image, AppFeatureRequestUploader
  belongs_to :employee, foreign_key: "request_by" #, class_name: "Employee"
  #belongs_to :employee, foreign_key: "assigned_to", class_name: "Working"
  belongs_to :app_list, foreign_key: "app_id"
  belongs_to :app_feature_type, foreign_key: "app_feature_type_id"
  belongs_to :app_user_satisfaction_level, foreign_key: "user_satisfaction_level_id"
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
    check_date = Date.today + 330.minutes
    #check_date = self.estimated_completion_date if self.estimated_completion_date.present?
    return "On Time in " if self.require_by_date >= check_date
    return "Delayed by " if self.require_by_date < check_date
  end

  def working_schedule
    return nil if self.estimated_completion_date.blank?
    check_date = self.estimated_completion_date
    return "On Time in " if self.require_by_date >= check_date
    return "Is delayed by " if self.require_by_date < check_date
  end

  def completion_schedule
    return nil if self.actual_completion_date.blank?
    check_date = self.actual_completion_date
    return "On Time in " if self.require_by_date >= check_date
    return "Was delayed by " if self.require_by_date < check_date
  end

  def update_date
  #10010 Feature in beta live
    if (self.current_status_id == 10010)
      current_time = (Time.zone.now + 330.minutes)
      self.update(actual_completion_date: current_time)
    end
  end
  
  # def self.image_full_url
#     if self.user_image.present?
#       return "http://3.0.3.57/uploads/app_feature_request/user_image/#{self.id}/#{self.user_image}"
#     end
#   end
  
  def image_full_url host
    # image_tag app_feature_comment.user_image.url
    #http://192.168.1.10:89/uploads/app_feature_comment/user_image/10500/embed-504165888.jpg
    #http://192.168.1.10:89/uploads/app_feature_comment/user_image/10463/Images-3.jpg
    return nil if self.user_image.blank?
    if host == "192.168.1.10"
      return "http://192.168.1.10:89#{self.user_image}" 
    else
      return "http://3.0.3.57#{self.user_image}" 
    end
  end
#after_update :update_date

private



def do_bug_count

end

def do_comment_count

end


end
