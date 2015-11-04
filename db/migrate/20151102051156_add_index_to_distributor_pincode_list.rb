class AddIndexToDistributorPincodeList < ActiveRecord::Migration
  def change
    add_index :distributor_pincode_lists, :pincode #, :unique => true
  end
end
