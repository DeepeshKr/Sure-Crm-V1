class AppVelocity < ActiveRecord::Base
  has_many :app_feature_request, foreign_key: "velocity_id"
end
