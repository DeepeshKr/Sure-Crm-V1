class CreateMediaTapeHeads < ActiveRecord::Migration
  def change
    create_table :media_tape_heads do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
