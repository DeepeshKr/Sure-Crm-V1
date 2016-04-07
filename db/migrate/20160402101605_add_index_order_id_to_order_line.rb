class AddIndexOrderIdToOrderLine < ActiveRecord::Migration
  def change
    add_index :order_lines, [:orderid, :productvariant_id]
  end
end
