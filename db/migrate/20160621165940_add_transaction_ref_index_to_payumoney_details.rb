class AddTransactionRefIndexToPayumoneyDetails < ActiveRecord::Migration
  def change
    add_index :payumoney_details, :transaction_ref
    add_index :payumoney_details, :payumoney_status_id
  end
end
