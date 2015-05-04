class CreateProductStockBooks < ActiveRecord::Migration
  def change
    create_table :product_stock_books do |t|
      t.date :stock_date
      t.integer :product_master_id
      t.integer :product_list_id
      t.string :ext_prod_code
      t.string :name
      t.integer :opening_qty
      t.decimal :opening_rate
      t.decimal :opening_value
      t.integer :purchased_qty
      t.decimal :purchased_rate
      t.decimal :purchased_value
      t.integer :returned_retail_qty
      t.decimal :returned_retail_rate
      t.decimal :returned_retail_value
      t.integer :returned_wholesale_qty
      t.decimal :returned_wholesale_rate
      t.decimal :returned_wholesale_value
      t.integer :returned_others_qty
      t.decimal :returned_others_rate
      t.decimal :returned_others_value
      t.integer :sold_retail_qty
      t.decimal :sold_retail_rate
      t.decimal :sold_retail_value
      t.integer :sold_wholesale
      t.decimal :sold_wholesale_rate
      t.decimal :sold_wholesale_value
      t.integer :sold_branch_qty
      t.decimal :sold_branch_rate
      t.decimal :sold_branch_value
      t.integer :corrections_qty
      t.decimal :corrections_rate
      t.decimal :corrections_value
      t.integer :closing_qty
      t.decimal :closing_rate
      t.decimal :closing_value

      t.timestamps null: false
    end
  end
end
