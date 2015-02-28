class ProductReportController < ApplicationController
	before_action :get_variables, only: [:list, :search, :details]
	respond_to :html

  def list
  	@productmasterlist = ProductMaster.all
  end

  def search

  end

  def details

  end

  private
    def get_variables
    	@empcode = current_user.employee_code
    	@empid = current_user.id
        @productmaster_id = params[:productmaster_id]
        @from_date = params[:from_date]
        @to_date = params[:to_date]   

    end
end
