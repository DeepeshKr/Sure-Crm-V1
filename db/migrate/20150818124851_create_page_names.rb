class CreatePageNames < ActiveRecord::Migration
  def change
    create_table :page_names do |t|
      t.string :name
      t.integer :sort_order
      t.text :description

      t.timestamps null: false
    end
  end
end
