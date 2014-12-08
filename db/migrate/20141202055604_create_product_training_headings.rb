class CreateProductTrainingHeadings < ActiveRecord::Migration
  def change
    create_table :product_training_headings do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
