class AddCallednoToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :calledno, :string
  end
end
