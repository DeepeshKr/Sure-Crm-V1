class AddEmployeeIdToMedia < ActiveRecord::Migration
  def change
    add_column :media, :employee_id, :integer
  end
end
