class AddCostToProductCostMaster < ActiveRecord::Migration
  def change
    add_column :product_cost_masters, :cost, :integer
    add_column :product_cost_masters, :revenue, :integer
  end
end
