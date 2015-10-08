class AddCityToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :city, :string
    add_column :order_masters, :pincode, :string
  end
end
