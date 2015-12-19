class CreateDistributorProductLists < ActiveRecord::Migration
  def change
    create_table :distributor_product_lists do |t|
      t.integer :product_list_id
      t.string :name
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
