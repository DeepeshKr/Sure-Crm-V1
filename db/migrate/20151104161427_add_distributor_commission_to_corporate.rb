class AddDistributorCommissionToCorporate < ActiveRecord::Migration
  def change
    add_column :corporates, :commission_percent, :decimal, precision: 4, scale: 5
  end
end
