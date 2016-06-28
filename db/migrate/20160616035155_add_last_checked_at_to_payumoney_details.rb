class AddLastCheckedAtToPayumoneyDetails < ActiveRecord::Migration
  def change
    add_column :payumoney_details, :last_check_at, :datetime
  end
end
