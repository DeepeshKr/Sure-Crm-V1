class AddReportingtoToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :reportingto, :integer
  end
end
