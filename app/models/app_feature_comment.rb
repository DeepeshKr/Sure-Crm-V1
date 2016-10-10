class AppFeatureComment < ActiveRecord::Base
   mount_uploader :user_image, AppFeatureCommentUploader
  #attr_accessor :image_full_url
  belongs_to :app_comment_type, foreign_key: "comment_type_id"
  belongs_to :app_comment_display_level, foreign_key: "display_level_id"
  belongs_to :employee, foreign_key: "comments_by_id"
  belongs_to :app_feature_request, foreign_key: "app_feature_request_id"

   validates :details,  :presence => { :message => "Please give a details" } #, :allow_blank => true
   validates :app_feature_request_id,  :presence => { :message => "No Feature selected!" }
   validates :comments_by_id,  :presence => { :message => "No comments by employee selected!" }
   validates :comment_type_id,  :presence => { :message => "No comment type selected!" }
   validates :display_level_id,  :presence => { :message => "No display type selected!" }
   
   def image_full_url host
     # image_tag app_feature_comment.user_image.url
     #http://192.168.1.10:89/uploads/app_feature_comment/user_image/10500/embed-504165888.jpg
     #http://192.168.1.10:89/uploads/app_feature_comment/user_image/10463/Images-3.jpg
     return nil if self.user_image.file.nil?
     if host == "192.168.1.10"
       return "http://192.168.1.10:89/uploads/app_feature_comment/user_image/#{self.id}/#{self.user_image_identifier}" 
     else
       return "http://3.0.3.57/uploads/app_feature_comment/user_image/#{self.id}/#{self.user_image_identifier}" 
     end
   end
end
