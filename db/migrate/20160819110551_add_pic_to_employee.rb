class AddPicToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :pic, :string
  end
end
