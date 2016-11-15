class CreatePendingOrders < ActiveRecord::Migration
  def change
    create_table :pending_orders do |t|
      t.integer :order_ref_id
      t.integer :order_no
      t.integer :order_dispatch_status_id
      t.decimal :cod_amount
      t.decimal :pay_u_amount
      t.integer :courier_list_id
      t.integer :pay_u_status_id
      t.integer :dispatch_call_status_id
      t.string :airway_bill
      t.string :pod

      t.timestamps null: false
    end
  end
end
