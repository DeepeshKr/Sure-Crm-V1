class CustdetailsController < ApplicationController
	respond_to :html
  def list
  	@custdetails = CUSTDETAILS.order("ordernum DESC").limit(50)
    respond_with(@custdetails)
  end

  def search
  
  end

  def details
  
  end
end
