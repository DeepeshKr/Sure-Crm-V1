class AddUpdatedToOrderUpdate < ActiveRecord::Migration
  def change
    add_column :order_updates, :updated, :boolean
  end
end
