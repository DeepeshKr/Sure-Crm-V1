class AppPriority < ActiveRecord::Base
  has_many :app_feature_request, foreign_key: "priority_id"
end
