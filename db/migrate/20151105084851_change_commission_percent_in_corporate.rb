class ChangeCommissionPercentInCorporate < ActiveRecord::Migration
  def change
  	change_column :corporates, :commission_percent, :decimal, precision: 5, scale: 4
  end
end
