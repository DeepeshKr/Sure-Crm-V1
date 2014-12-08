class AddAddresstypeidToCustomerAddress < ActiveRecord::Migration
  def change
    add_column :customer_addresses, :addresstypeid, :integer
  end
end
