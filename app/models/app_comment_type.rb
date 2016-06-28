class AppCommentType < ActiveRecord::Base
    has_many :app_feature_comment, foreign_key: "comment_type_id"
end
