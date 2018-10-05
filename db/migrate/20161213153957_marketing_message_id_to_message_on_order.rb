class MarketingMessageIdToMessageOnOrder < ActiveRecord::Migration
  def change
     add_column :message_on_orders, :marketing_message_id, :integer
     
     add_index :message_on_orders, :marketing_message_id
     
     add_index :marketing_messages, :start_date
     add_index :marketing_messages, :end_date
     add_index :marketing_messages, :order_paymentmodeid
  end
end
