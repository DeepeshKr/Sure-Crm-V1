class AddPaymentWaitingToOrderUpdate < ActiveRecord::Migration
  def change
    add_column :order_updates, :payment_waiting, :datetime
    add_column :order_updates, :payment_description, :string
    
    add_index :order_updates, :order_date
    add_index :order_updates, :payment_waiting
    add_index :order_updates, :order_id
    add_index :order_updates, :orderno
    
  end
end
