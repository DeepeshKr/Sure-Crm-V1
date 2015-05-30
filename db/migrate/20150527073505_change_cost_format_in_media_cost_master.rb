class ChangeCostFormatInMediaCostMaster < ActiveRecord::Migration
    def self.up
    change_table :media_cost_masters do |t|
      t.change :cost_per_sec, :decimal, :precision => 10, :scale => 2
    end
  end
  def self.down
    change_table :media_cost_masters do |t|
      t.change :cost_per_sec, :integer
    end
  end
end
