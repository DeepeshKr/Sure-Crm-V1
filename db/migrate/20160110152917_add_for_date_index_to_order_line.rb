class AddForDateIndexToOrderLine < ActiveRecord::Migration
  def change
    add_index :order_lines, :orderdate
    add_index :order_lines, :orderid
    add_index :order_lines, :productvariant_id
    add_index :order_lines, :product_list_id
    add_index :order_lines, :product_master_id
    
  end
end
