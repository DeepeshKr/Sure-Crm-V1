class CreateProductTestPpos < ActiveRecord::Migration
  def change
    create_table :product_test_ppos do |t|
      t.string :name
      t.string :prod_code
      t.string :barcode
      t.float :basic_price
      t.float :shipping
      t.string :channel
      t.date :aired_date
      t.string :slot
      t.integer :orders
      t.float :ppo
      t.float :ad_cost
      t.text :description

      t.timestamps null: false
    end
  end
end
