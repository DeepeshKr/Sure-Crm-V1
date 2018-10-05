class Employee < ActiveRecord::Base
   mount_uploader :pic, EmployeeUploader
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
  has_many :help_files, foreign_key: "employee_id"
def fullname
  return "#{self.title} #{self.first_name} #{self.last_name}"
  #(self.title || "NA") + " " + (self.first_name || "NA" )  + " " + (self.last_name || "NA" ) + " (" + (self.designation || "NA" ) + ")"
end

def open_orders
  OrderMaster.where("interaction_master_id IS NULL").where(employee_id: self.id).pluck(:id).count ||= 0
end

def last_logged
  session = Sessions.where(employee_code: self.employeecode).order(:created_at)
  #.created_at
  return nil if session.blank?
  session.last.created_at
  #"#{( + 330.minutes).strftime("%d-%b-%Y %H:%M:%S")} from IP #{session.last.userip}"
  
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
 return "#{self.first_name} #{self.last_name} (#{self.employeecode.to_s})" 
   #(self.first_name || "NA") + " " + (self.last_name || " ") + (self.employeecode.to_s || " ")
end

def image_full_url host
  # image_tag app_feature_comment.user_image.url
  #http://192.168.1.10:89/uploads/app_feature_comment/user_image/10500/embed-504165888.jpg
  #http://192.168.1.10:89/uploads/app_feature_comment/user_image/10463/Images-3.jpg
  return nil if self.pic.file.nil?
  if host == "192.168.1.10"
    return "http://192.168.1.10:89/uploads/app_feature_comment/user_image/#{self.id}/#{self.pic_identifier}" 
  else
    return "http://3.0.3.57/uploads/app_feature_comment/user_image/#{self.id}/#{self.pic_identifier}" 
  end
end

private
  def downcase
     if emailid.present?
        emailid = emailid.to_s.downcase.gsub(/\s+/, '')
    end
    employeecode = employeecode.to_s.downcase
  end
end
