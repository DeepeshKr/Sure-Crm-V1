class AddCorporateTypeIdToCorporate < ActiveRecord::Migration
  def change
    add_column :corporates, :corporate_type_id, :integer
  end
end
