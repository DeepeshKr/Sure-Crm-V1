class CreateDistributorMissedOrders < ActiveRecord::Migration
  def change
    create_table :distributor_missed_orders do |t|
      t.integer :corporate_id
      t.integer :missed_type_id
      t.decimal :order_value
      t.integer :order_no
      t.integer :order_id
      t.text :description

      t.timestamps null: false
    end
  end
end
