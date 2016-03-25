class AddShippedToReturnRate < ActiveRecord::Migration
  def change
    add_column :return_rates, :shipped, :integer
  end
end
