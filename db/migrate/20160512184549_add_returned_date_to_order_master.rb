class AddReturnedDateToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :returned_date, :datetime
    add_index :order_masters, :returned_date
  end
end
