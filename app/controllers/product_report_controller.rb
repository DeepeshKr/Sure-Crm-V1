class ProductReportController < ApplicationController
	before_action :get_variables, only: [:list, :search, :details]
  before_action :dropdowns, only: [:list, :search, :details]
	respond_to :html

  def list
  #prod=TOTS&from_date=02%2F24%2F2015&to_date=02%2F23%2F2015
  if params[:prod].present? && params[:from_date].present? && params[:to_date].present?
    prod = params[:prod]
    from_date = Time.strptime(params[:from_date], '%m/%d/%Y')
    to_date = Time.strptime(params[:to_date], '%m/%d/%Y')
    
    @prod = prod
    @from_date = from_date.to_formatted_s(:rfc822)
    @to_date =  to_date.to_formatted_s(:rfc822)

    @purchases_new = PURCHASES_NEW.where(prod: prod).where("TRUNC(rdate) >= ? and TRUNC(rdate) <= ?", from_date, to_date).limit(10)
    @vpp = VPP.where(prod: prod).where("TRUNC(paiddate) >= ? and TRUNC(paiddate) <= ?", from_date, to_date).limit(100)
    @newwlsdet = NEWWLSDET.where(prod: prod).where("TRUNC(shdate) >= ? and TRUNC(shdate) <= ?", from_date, to_date).limit(10)

  else
    @purchases_new = PURCHASES_NEW.all.limit(10)
    @vpp = VPP.all.limit(10)
    @newwlsdet = NEWWLSDET.all.limit(10)
  end
    

  end

  def search

  end

  def details

  end

  private
    def dropdowns
        @productmasterlist = ProductMaster.all
    end
    def get_variables
    	@empcode = current_user.employee_code
    	@empid = current_user.id
        @productmaster_id = params[:productmaster_id]
        @from_date = params[:from_date]
        @to_date = params[:to_date]   

    end
end
