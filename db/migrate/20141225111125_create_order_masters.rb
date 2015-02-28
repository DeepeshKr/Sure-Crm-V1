class CreateOrderMasters < ActiveRecord::Migration
  def change
    create_table :order_masters do |t|
      t.datetime :orderdate
      t.string :employeecode
      t.integer :employee_id
      t.integer :customer_id
      t.integer :customer_address_id
      t.string :billno
      t.string :external_order_no
      t.integer :pieces
      t.float :subtotal
      t.float :taxes
      t.float :shipping
      t.float :codcharges
      t.float :total
      t.integer :orderstatusmaster_id
      t.integer :orderpaymentmode_id
      t.integer :campaignplaylist_id
      t.text :notes

      t.timestamps
    end
  end
end
