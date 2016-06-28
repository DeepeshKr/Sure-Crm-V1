class AppUserSatisfactionLevel < ActiveRecord::Base
  has_many :app_feature_request, foreign_key: "user_satisfaction_level_id"
end
