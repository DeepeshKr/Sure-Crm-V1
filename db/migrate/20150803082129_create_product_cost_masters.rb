class CreateProductCostMasters < ActiveRecord::Migration
  def change
    create_table :product_cost_masters do |t|
      t.integer :product_id
      t.string :prod
      t.string :barcode
      t.decimal :cost, precision: 10, scale: 2
      t.decimal :revenue, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
