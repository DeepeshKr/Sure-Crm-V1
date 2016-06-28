class AppList < ActiveRecord::Base
  has_many :app_feature_request, foreign_key: "app_id"
end
