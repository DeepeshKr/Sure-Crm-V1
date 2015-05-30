class FixColumnNameInMediaCostMaster < ActiveRecord::Migration
  def change
  	rename_column :media_cost_masters, :cost_per_sec, :total_cost
  end
end
