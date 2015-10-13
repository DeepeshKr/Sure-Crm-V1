class AddCorporateIdToDistributorPincodeList < ActiveRecord::Migration
  def change
    add_column :distributor_pincode_lists, :corporate_id, :integer
  end
end
