class CreatePincodeServiceLevels < ActiveRecord::Migration
  def change
    create_table :pincode_service_levels do |t|
      t.string :pincode
      t.integer :total_orders
      t.float :total_value
      t.datetime :last_ran_on
      t.text :description
      t.integer :courier_id
      t.integer :time_to_deliver
      t.integer :cod_avail
      t.integer :distributor_avail
      t.integer :paid_order
      t.float :paid_value

      t.timestamps null: false
    end
  end
end
