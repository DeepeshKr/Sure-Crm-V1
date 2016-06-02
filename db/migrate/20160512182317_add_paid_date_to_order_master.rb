class AddPaidDateToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :process_date, :datetime
    add_index :order_masters, :process_date
    add_column :order_masters, :ship_date, :datetime
    add_index :order_masters, :ship_date
    add_column :order_masters, :cancelled_date, :datetime
    add_index :order_masters, :cancelled_date
    add_column :order_masters, :paid_date, :datetime
    add_index :order_masters, :paid_date
    add_column :order_masters, :refund_date, :datetime
    add_index :order_masters, :refund_date
   
  end
end
