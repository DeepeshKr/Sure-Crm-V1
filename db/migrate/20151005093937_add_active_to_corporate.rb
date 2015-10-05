class AddActiveToCorporate < ActiveRecord::Migration
  def change
    add_column :corporates, :active, :integer
  end
end
