class CreateProductSampleStocks < ActiveRecord::Migration
  def change
    create_table :product_sample_stocks do |t|
      t.integer :product_master_id
      t.integer :product_list_id
      t.string :product_name
      t.string :prod_code
      t.string :barcode
      t.float :basic_price
      t.float :shipping
      t.date :air_date
      t.integer :orders
      t.integer :stock
      t.text :description

      t.timestamps null: false
    end
  end
end
