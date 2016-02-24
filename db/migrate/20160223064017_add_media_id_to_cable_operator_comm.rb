class AddMediaIdToCableOperatorComm < ActiveRecord::Migration
  def change
    add_column :cable_operator_comms, :media_id, :integer
  end
end
