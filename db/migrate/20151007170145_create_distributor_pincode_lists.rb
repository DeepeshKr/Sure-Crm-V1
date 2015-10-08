class CreateDistributorPincodeLists < ActiveRecord::Migration
  def change
    create_table :distributor_pincode_lists do |t|
      t.string :city
      t.string :state
      t.string :locality
      t.integer :sort_order
      t.string :pincode

      t.timestamps null: false
    end
  end
end
