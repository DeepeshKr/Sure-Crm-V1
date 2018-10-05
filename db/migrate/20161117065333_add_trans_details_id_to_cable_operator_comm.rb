class AddTransDetailsIdToCableOperatorComm < ActiveRecord::Migration
  def change
    add_column :cable_operator_comms, :transdetails_id, :integer
    
     add_index :cable_operator_comms, :transdetails_id
  end
end
