class AddBarcodeToProductStockBook < ActiveRecord::Migration
  def change
    add_column :product_stock_books, :list_barcode, :string
  end
end
