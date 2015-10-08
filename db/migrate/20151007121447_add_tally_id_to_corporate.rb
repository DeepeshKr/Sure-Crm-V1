class AddTallyIdToCorporate < ActiveRecord::Migration
  def change
    add_column :corporates, :tally_id, :string
    add_column :corporates, :c_form, :string
    add_column :corporates, :cst_no, :string
    add_column :corporates, :gst_no, :string
    add_column :corporates, :vat_no, :string
    add_column :corporates, :tin_no, :string
    add_column :corporates, :rupee_balance, :decimal, precision: 14, scale: 2
  end
end
