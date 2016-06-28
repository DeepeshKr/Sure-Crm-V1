class AddChangeCostPerSecToMediaCostMaster < ActiveRecord::Migration
  def change
    change_column :media_cost_masters, :cost_per_sec, :decimal, :precision => 10, :scale => 4
  end
end
