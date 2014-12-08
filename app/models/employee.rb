class Employee < ActiveRecord::Base
  before_save {email.downcase! }
 before_save {employee_code.downcase! }
 validates :first_name,  presence: true, length: { maximum: 50 }
validates :last_name,  presence: true, length: { maximum: 50 }
 validates :employeecode,  presence: true, uniqueness: true, length:  { maximum: 50 }
   
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :emailid, allow_blank: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

 #validates_uniqueness_of :emailid, :allow_blank => true
# validates_uniqueness_of :employeecode, allow_blank: false
 
  belongs_to :employment_type
  belongs_to :employee_role
  
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "reporting_to_id"
 
  belongs_to :manager, class_name: "Employee"

has_many :interaction_category
def fullname
   self.first_name + self.last_name + " (" + self.designation + ")"
end
end
