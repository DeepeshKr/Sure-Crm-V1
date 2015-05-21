class CreatePackingCosts < ActiveRecord::Migration
  def change
    create_table :packing_costs do |t|

      t.timestamps null: false
    end
  end
end
