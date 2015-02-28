class CreateOrderLines < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
      t.integer :orderid
      t.datetime :orderdate
      t.string :employeecode
      t.integer :employee_id
      t.string :external_ref_no
      t.integer :productvariant_id
      t.integer :pieces
      t.float :subtotal
      t.float :taxes
      t.float :shipping
      t.float :codcharges
      t.float :total
      t.integer :orderlinestatusmaster_id
      t.integer :productline_id
      t.text :description
      t.datetime :estimatedshipdate
      t.datetime :estimatedarrivaldate
      t.datetime :orderchecked
      t.datetime :actualshippate

      t.timestamps
    end
  end
end
