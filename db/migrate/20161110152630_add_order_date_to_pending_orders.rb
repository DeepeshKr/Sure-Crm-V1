class AddOrderDateToPendingOrders < ActiveRecord::Migration
  def change
    add_column :pending_orders, :order_date, :datetime
    
    add_index :pending_orders, :order_date
  end
end
