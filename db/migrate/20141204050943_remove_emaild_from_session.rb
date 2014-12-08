class RemoveEmaildFromSession < ActiveRecord::Migration
  def change
    remove_column :sessions, :emaild, :string
  end
end
