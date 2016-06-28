class AddTransactionRefToPayumoneyDetails < ActiveRecord::Migration
  def change
    add_column :payumoney_details, :message_url, :text
    add_column :payumoney_details, :transaction_ref, :string
    add_column :payumoney_details, :payumoney_status_id, :integer
    add_column :payumoney_details, :transaction_history, :text
  end
end
