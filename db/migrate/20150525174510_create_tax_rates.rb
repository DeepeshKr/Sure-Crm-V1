class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.decimal :tax_rate, :precision => 6, :scale => 5
      t.decimal :reverse_rate, :precision => 10, :scale => 9
      t.text :description

      t.timestamps null: false
    end
  end
end
