class CreateDistributorMissedPincodes < ActiveRecord::Migration
  def change
    create_table :distributor_missed_pincodes do |t|
      t.string :pincode
      t.integer :no_of_orders
      t.float :total_value
      t.datetime :last_ran_on
      t.text :description

      t.timestamps null: false
    end
  end
end
