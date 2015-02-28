class CreateProductTrainingManuals < ActiveRecord::Migration
  def change
    create_table :product_training_manuals do |t|
      t.integer :productid
      t.string :name
      t.text :description
      t.text :quicknotes
      t.integer :product_training_heading_id

      t.timestamps
    end
  end
end
