class CreateDistributorStockBooks < ActiveRecord::Migration
  def change
    create_table :distributor_stock_books do |t|
      t.integer :corporate_id
      t.integer :product_master_id
      t.integer :product_variant_id
      t.integer :product_list_id
      t.string :prod
      t.integer :opening_qty
      t.decimal :opening_value, precision: 10, scale: 2
      t.integer :sold_qty
      t.decimal :sold_value, precision: 10, scale: 2
      t.integer :return_qty
      t.decimal :return_value, precision: 10, scale: 2
      t.integer :closing_qty
      t.decimal :closing_value, precision: 10, scale: 2
      t.date :book_date
      t.string :list_barcode

      t.timestamps null: false
    end
  end
end
