class AddPanCardToCorporate < ActiveRecord::Migration
  def change
    add_column :corporates, :pan_card_no, :string
  end
end
