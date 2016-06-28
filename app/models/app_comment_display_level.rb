class AppCommentDisplayLevel < ActiveRecord::Base
  has_many :app_feature_comment, foreign_key: "display_level_id"
end
