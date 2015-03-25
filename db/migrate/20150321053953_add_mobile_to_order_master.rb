class AddMobileToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :mobile, :string
  end
end
