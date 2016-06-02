class AddShortCodeToState < ActiveRecord::Migration
  def change
    add_column :states, :short_code, :string
    add_index :states, :short_code
  end
end
