class AddWeightToProductMaster < ActiveRecord::Migration
  def change
    add_column :product_masters, :weight_kg, :decimal, precision: 8, scale: 4
  end
end
