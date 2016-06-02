class AddOrderIdToMessageOnOrder < ActiveRecord::Migration
  def change
    add_column :message_on_orders, :order_id, :integer
    add_index :message_on_orders, :order_id
    add_index :message_on_orders, :message_type_id
    add_index :message_on_orders, :message_status_id
    add_index :message_on_orders, :customer_id
    add_index :message_on_orders, :mobile_no
    add_column :message_on_orders, :long_url, :text
  end
end
