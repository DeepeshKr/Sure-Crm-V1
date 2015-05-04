class CreateProductStocks < ActiveRecord::Migration
  def change
    create_table :product_stocks do |t|
      t.integer :product_master_id
      t.integer :product_list_id
      t.integer :current_stock
      t.string :ext_prod_code
      t.string :barcode
      t.date :checked_date
      t.string :emp_code
      t.integer :emp_id

      t.timestamps null: false
    end
  end
end
