class CreateSalesReportPayUSteps < ActiveRecord::Migration
  def change
    create_table :sales_report_pay_u_steps do |t|
      t.string :name
      t.text :description
      t.integer :min_value
      t.integer :max_value
      t.boolean :active

      t.timestamps null: false
    end
  end
end
