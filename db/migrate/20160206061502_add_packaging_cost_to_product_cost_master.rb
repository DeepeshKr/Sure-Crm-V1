class AddPackagingCostToProductCostMaster < ActiveRecord::Migration
  def change
    add_column :product_cost_masters, :packaging_cost, :decimal
  end
end
