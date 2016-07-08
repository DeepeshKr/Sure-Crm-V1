class AddNoOfLinksToPayumoneyDetails < ActiveRecord::Migration
  def change
    add_column :payumoney_details, :no_of_links, :integer
  end
end
