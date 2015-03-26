class AddEmployeeIdToInteractionMaster < ActiveRecord::Migration
  def change
    add_column :interaction_masters, :employee_id, :integer
    add_column :interaction_masters, :employee_code, :string
  end
end
