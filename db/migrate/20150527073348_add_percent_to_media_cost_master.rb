class AddPercentToMediaCostMaster < ActiveRecord::Migration
  def change
    add_column :media_cost_masters, :slot_percent, :decimal, :precision => 5, :scale => 4
  end
end
