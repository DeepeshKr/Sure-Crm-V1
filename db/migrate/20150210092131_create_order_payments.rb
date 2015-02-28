class CreateOrderPayments < ActiveRecord::Migration
  def change
    create_table :order_payments do |t|
      t.integer :order_master_id
      t.string :ref_no
      t.integer :orderpaymentmode_id
      t.date :paid_date
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
