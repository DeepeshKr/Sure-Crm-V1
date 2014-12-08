class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.float :vatpercent
      t.string :description

      t.timestamps
    end
  end
end
