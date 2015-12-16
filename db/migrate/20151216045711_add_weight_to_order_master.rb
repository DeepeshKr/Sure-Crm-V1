class AddWeightToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :weight_kg, :integer
  end
end
