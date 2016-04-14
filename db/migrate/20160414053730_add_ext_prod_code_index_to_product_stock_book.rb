class AddExtProdCodeIndexToProductStockBook < ActiveRecord::Migration
  def change
    add_index :product_stock_books, :ext_prod_code
    add_index :product_stock_books, :list_barcode
  end
end
