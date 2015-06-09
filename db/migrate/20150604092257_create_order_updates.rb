class CreateOrderUpdates < ActiveRecord::Migration
  def change
    create_table :order_updates do |t|
      t.integer :order_id
      t.integer :order_line_id
      t.decimal :order_value, :precision => 10, :scale => 2
      t.string :orderno
      t.date :order_date
      t.date :entry_date
      t.date :shipped_date
      t.date :return_date
      t.date :cancel_date
      t.date :refund_date
      t.date :paid_date
      t.decimal :paid_value, :precision => 10, :scale => 2


      t.timestamps null: false
    end
  end
end
