class User < ActiveRecord::Base
 belongs_to :employee_role, foreign_key: "role"
 belongs_to :employee, foreign_key: "employee_code"


#enum role: [:user, :manager, :accounts, :admin]

 after_initialize :set_default_role, :if => :new_record?
 
  before_save :downcase


 validates :name,  presence: true, length: { maximum: 50 }
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, allow_blank: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
 validates_uniqueness_of :email, :allow_nil => true
                    
 validates :employee_code,  presence: true, length: { maximum: 50 }

 #self.role ||= :user
# def role_enum
#   [:user, :manager, :accounts, :admin]
# end
#Has secure password is required for password in the table
has_secure_password

def set_default_role
100
end

private
  def downcase
     if email.present?
        email = email.to_s.downcase.gsub(/\s+/, '')
    end
    employeecode = employeecode.to_s.downcase
  end
 # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
end
