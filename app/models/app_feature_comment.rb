class AppFeatureComment < ActiveRecord::Base
  belongs_to :app_comment_type, foreign_key: "comment_type_id"
  belongs_to :app_comment_display_level, foreign_key: "display_level_id"
  belongs_to :employee, foreign_key: "comments_by_id"
  belongs_to :app_feature_request, foreign_key: "app_feature_request_id"

   validates :details,  :presence => { :message => "Please give a details" } #, :allow_blank => true
   validates :app_feature_request_id,  :presence => { :message => "No Feature selected!" }
   validates :comments_by_id,  :presence => { :message => "No comments by employee selected!" }
   validates :comment_type_id,  :presence => { :message => "No comment type selected!" }
   validates :display_level_id,  :presence => { :message => "No display type selected!" }

end
