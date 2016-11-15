class AddOrderIndexToPendingOrders < ActiveRecord::Migration
  def change
    add_index :pending_orders, :order_ref_id
    add_index :pending_orders, :order_no
    add_index :pending_orders, :order_dispatch_status_id
    add_index :pending_orders, :courier_list_id
    add_index :pending_orders, :pay_u_status_id
    add_index :pending_orders, :dispatch_call_status_id
    add_index :pending_orders, :airway_bill
    add_index :pending_orders, :pod
    
    add_index :order_dispatch_statuses, :name
    add_index :order_dispatch_statuses, :sort_order

    add_index :dispatch_call_statuses, :name
    add_index :dispatch_call_statuses, :sort_order
  end
end
