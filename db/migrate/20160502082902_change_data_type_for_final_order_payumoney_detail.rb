class ChangeDataTypeForFinalOrderPayumoneyDetail < ActiveRecord::Migration
  def change
    remove_column :payumoney_details, :final_order_id
    add_column :payumoney_details, :final_order_id, :string
    add_index :payumoney_details, :final_order_id
    add_column :payumoney_details, :full_response, :text
  end
end
