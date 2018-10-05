class AddEmployeeIdToOrderPayment < ActiveRecord::Migration
  def change
    add_column :order_payments, :employee_id, :integer
    add_column :order_payments, :paid_amount, :decimal, :precision => 10, :scale => 4
    add_column :order_payments, :order_no, :integer
    
    
    add_index :order_payments, :order_master_id
    add_index :order_payments, :orderpaymentmode_id
    add_index :order_payments, :paid_date
    add_index :order_payments, :employee_id
    add_index :order_payments, :order_no
  end
end
