class CreateCableOpertorComms < ActiveRecord::Migration
  def change
    create_table :cable_operator_comms do |t|
      t.integer :order_no
      t.date :order_date
      t.string :channel
      t.string :product
      t.decimal :amount
      t.string :customer_name
      t.string :city
      t.decimal :comm
      t.text :description

      t.timestamps null: false
    end
  end
end
