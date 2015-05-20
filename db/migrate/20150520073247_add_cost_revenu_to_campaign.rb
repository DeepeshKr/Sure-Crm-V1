class AddCostRevenuToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :total_cost, :decimal
    add_column :campaigns, :total_revenue, :decimal
  end
end
