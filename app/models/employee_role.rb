class EmployeeRole < ActiveRecord::Base
 has_many :employee, foreign_key: "employee_role_id"
 has_many :users, foreign_key: "role"
end
