class User < ActiveRecord::Base
 before_save {email.downcase! }
 before_save {employee_code.downcase! }
 validates :name,  presence: true, length: { maximum: 50 }
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, allow_blank: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
 validates_uniqueness_of :email, :allow_nil => true
                    
 validates :employee_code,  presence: true, length: { maximum: 50 }

has_secure_password
end
