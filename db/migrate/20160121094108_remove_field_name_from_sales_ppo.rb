class RemoveFieldNameFromSalesPpo < ActiveRecord::Migration
  def change
    remove_column :sales_ppos, :media_cost, :decimal
    remove_column :sales_ppos, :media_cost_total, :decimal
  end
end
