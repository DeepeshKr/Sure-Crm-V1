class AddOrderIdToCableOperatorComm < ActiveRecord::Migration
  def change
    add_column :cable_operator_comms, :order_id, :integer
  end
end
