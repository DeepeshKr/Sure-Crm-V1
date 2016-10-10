class SalesPpoEmailAlert < ActiveRecord::Base
  validates :email_id, presence: true, uniqueness: {
    message: "You have already added the email id, no need to keep adding!" }
    
  # validates_format_of :email_id {
#      },:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
# 
   validates :email_id, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ , message: "The email id has to be valid!"}

end
