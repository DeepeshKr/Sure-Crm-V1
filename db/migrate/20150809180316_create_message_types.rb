class CreateMessageTypes < ActiveRecord::Migration
  def change
    create_table :message_types do |t|
      t.string :name
      t.string :description
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
