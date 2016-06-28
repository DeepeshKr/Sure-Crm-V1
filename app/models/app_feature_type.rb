class AppFeatureType < ActiveRecord::Base
  has_many :app_feature_request, foreign_key: "app_feature_type_id"
end
