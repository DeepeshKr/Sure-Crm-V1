class AddValueToProductStockAdjust < ActiveRecord::Migration
  def change
    add_column :product_stock_adjusts, :total, :decimal
    add_column :product_stock_adjusts, :rate, :decimal
  end
end
