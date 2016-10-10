class AddOrderIdToCustomerOrderList < ActiveRecord::Migration
  def change
    add_column :customer_order_lists, :order_id, :integer
    add_index :customer_order_lists, :order_id
    add_column :customer_order_lists, :dept_master, :string
    add_index :customer_order_lists, :dept_master
    add_column :customer_order_lists, :state_code, :string
    add_index :customer_order_lists, :state_code
    add_index :customer_order_lists, :ordernum
    add_index :customer_order_lists, :tel1
    add_index :customer_order_lists, :state
    add_index :customer_order_lists, :prod1
    add_index :customer_order_lists, :pincode
    add_index :customer_order_lists, :city
    add_index :customer_order_lists, :tel2

  end
end
