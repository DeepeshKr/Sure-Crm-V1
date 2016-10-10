class AddInDateToCustomerOrderList < ActiveRecord::Migration
  def change
    add_column :customer_order_lists, :in_date, :date
  end
end
