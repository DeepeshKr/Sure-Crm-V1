class CreateProductActiveCodes < ActiveRecord::Migration
  def change
    create_table :product_active_codes do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
