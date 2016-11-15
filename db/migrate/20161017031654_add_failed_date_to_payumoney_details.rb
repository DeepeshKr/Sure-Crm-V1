class AddFailedDateToPayumoneyDetails < ActiveRecord::Migration
  def change
    add_column :payumoney_details, :failed_time, :datetime
    add_column :payumoney_details, :failed_count, :integer
  end
end
