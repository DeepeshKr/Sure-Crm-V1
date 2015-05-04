class CreateProductStockAdjusts < ActiveRecord::Migration
  def change
    create_table :product_stock_adjusts do |t|
      t.integer :product_master_id
      t.integer :product_list_id
      t.decimal :change_stock
      t.string :ext_prod_code
      t.string :barcode
      t.date :created_date
      t.string :emp_code
      t.integer :emp_id
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
