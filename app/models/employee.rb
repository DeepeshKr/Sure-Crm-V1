class Employee < ActiveRecord::Base

 before_save :downcase

 validates :first_name,  presence: true, length: { maximum: 50 }
#validates :last_name,  presence: true, length: { maximum: 50 }
 validates :employeecode,  presence: true, uniqueness: true, length:  { maximum: 50 }

 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :emailid, allow_blank: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
 # uniqueness: true,
 # validates_uniqueness_of :emailid, :allow_blank => true
 # validates_uniqueness_of :employeecode, allow_blank: false

  belongs_to :employment_type
  belongs_to :employee_role, foreign_key: "employee_role_id"

  belongs_to :manager, class_name: "Employee", foreign_key: "reporting_to_id"
  has_many :subordinates, class_name: "Employee",foreign_key: "reporting_to_id"

  has_many :user, foreign_key: "employee_code"
  has_many :medium, foreign_key: "employee_id"

  has_many :page_trail, foreign_key: "employee_id"
  has_many :interaction_category, foreign_key: "employeeid"
  has_many :order_master, foreign_key: "employee_id"
  has_many :interaction_master, foreign_key: "employee_id"
  has_many :interaction_transcript, foreign_key: "employee_id"
  has_many :app_feature_comment, foreign_key: "comments_by_id"
  has_many :app_feature_request, foreign_key: "request_by"
  has_many :app_feature_request, foreign_key: "assigned_to"
def fullname
  return "#{self.title} #{self.first_name} #{self.last_name}"
  #(self.title || "NA") + " " + (self.first_name || "NA" )  + " " + (self.last_name || "NA" ) + " (" + (self.designation || "NA" ) + ")"
end

def self.full_name id
  employee = Employee.find(id)
  return "#{employee.title} #{employee.first_name} #{employee.last_name}"
  #(self.title || "NA") + " " + (self.first_name || "NA" )  + " " + (self.last_name || "NA" ) + " (" + (self.designation || "NA" ) + ")"
end

def name
   (self.first_name || "NA") + " " + (self.last_name || " ")
end

def employee_name
   (self.first_name || "NA") + " " + (self.last_name || " ") + (self.employeecode.to_s || " ")
end

private
  def downcase
     if emailid.present?
        emailid = emailid.to_s.downcase.gsub(/\s+/, '')
    end
    employeecode = employeecode.to_s.downcase
  end
end
