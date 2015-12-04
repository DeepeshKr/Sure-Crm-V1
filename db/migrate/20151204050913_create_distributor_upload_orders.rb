class CreateDistributorUploadOrders < ActiveRecord::Migration
  def change
    create_table :distributor_upload_orders do |t|
      t.integer :order_id
      t.integer :ext_order_id
      t.datetime :last_ran_on
      t.text :description
      t.integer :online_order_id
      t.datetime :online_last_ran_on
      t.text :online_description

      t.timestamps null: false
    end
  end
end
