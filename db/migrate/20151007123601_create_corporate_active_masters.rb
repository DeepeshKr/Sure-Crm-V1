class CreateCorporateActiveMasters < ActiveRecord::Migration
  def change
    create_table :corporate_active_masters do |t|
      t.string :name
      t.integer :sort_order
      t.text :description

      t.timestamps null: false
    end
  end
end
