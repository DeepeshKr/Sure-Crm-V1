class AddUseripSessionToOrderMaster < ActiveRecord::Migration
  def change
  	add_column :order_masters, :userip, :string
    add_column :order_masters, :sessionid, :string
  end
end
