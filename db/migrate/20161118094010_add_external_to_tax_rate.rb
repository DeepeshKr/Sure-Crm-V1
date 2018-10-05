class AddExternalToTaxRate < ActiveRecord::Migration
  def change
    add_column :tax_rates, :is_external, :boolean
  end
end
