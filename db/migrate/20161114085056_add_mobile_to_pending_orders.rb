class AddMobileToPendingOrders < ActiveRecord::Migration
  def change
    add_column :pending_orders, :tel_1, :string
    add_column :pending_orders, :tel_2, :string
    add_column :pending_orders, :manifest, :string
    add_column :pending_orders, :courier_name, :string
    
     add_index :pending_orders, :tel_1
     add_index :pending_orders, :tel_2
     add_index :pending_orders, :manifest
     add_index :pending_orders, :courier_name
  end
end
