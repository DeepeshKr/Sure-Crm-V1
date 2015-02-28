class CreateOrderpaymentmodes < ActiveRecord::Migration
  def change
    create_table :orderpaymentmodes do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
