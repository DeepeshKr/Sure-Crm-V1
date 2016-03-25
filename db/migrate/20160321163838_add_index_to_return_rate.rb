class AddIndexToReturnRate < ActiveRecord::Migration
  def change
    add_index :return_rates, :name
    add_index :return_rates, :no_of_days
  end
end
