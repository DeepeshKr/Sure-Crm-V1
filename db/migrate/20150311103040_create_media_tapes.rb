class CreateMediaTapes < ActiveRecord::Migration
  def change
    create_table :media_tapes do |t|
      t.string :name
      t.integer :duration_secs
      t.integer :tape_ext_ref_id
      t.string :unique_tape_name
      t.integer :media_id
      t.integer :product_variant_id
      t.text :description

      t.timestamps null: false
    end
  end
end
