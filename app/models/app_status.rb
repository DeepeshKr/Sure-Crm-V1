class AppStatus < ActiveRecord::Base
  has_many :app_feature_request, foreign_key: "current_status_id"
end
