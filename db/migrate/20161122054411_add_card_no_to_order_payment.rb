class AddCardNoToOrderPayment < ActiveRecord::Migration
  def change
    add_column :order_payments, :card_no, :string
  end
end
