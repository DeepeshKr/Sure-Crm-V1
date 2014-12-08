class AddIndexToUsersEmployeeCode < ActiveRecord::Migration
  def change
     add_index :users, :employee_code, unique: true
  end
end
