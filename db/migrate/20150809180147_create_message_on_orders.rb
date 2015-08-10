class CreateMessageOnOrders < ActiveRecord::Migration
  def change
    create_table :message_on_orders do |t|
      t.integer :customer_id
      t.integer :message_type_id
      t.integer :message_status_id
      t.string :message
      t.string :response
      t.string :mobile_no
      t.string :alt_mobile_no

      t.timestamps null: false
    end
  end
end
