class AddCostPerSecToMediaCostMaster < ActiveRecord::Migration
  def change
    add_column :media_cost_masters, :cost_per_sec, :decimal
    add_column :media_cost_masters, :starting_sec, :integer
    add_index :media_cost_masters, :starting_sec
    add_column :media_cost_masters, :ending_sec, :integer
    add_index :media_cost_masters, :ending_sec
  end
end
