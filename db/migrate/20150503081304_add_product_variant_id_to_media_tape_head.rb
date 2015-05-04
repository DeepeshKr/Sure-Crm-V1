class AddProductVariantIdToMediaTapeHead < ActiveRecord::Migration
  def change
    add_column :media_tape_heads, :product_variant_id, :integer
  end
end
