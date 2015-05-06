class CustdetailsController < ApplicationController
	respond_to :html
  def list
  	if params[:from_date].present? && params[:to_date].present?
        #prod = params[:prod]
        from_date = Time.strptime(params[:from_date], '%m/%d/%Y') #- 1.days
        to_date = Time.strptime(params[:to_date], '%m/%d/%Y') 
         @from_date = from_date.to_formatted_s(:rfc822)
        @to_date =  (to_date).to_formatted_s(:rfc822) 
    	
    	 @custdetails = CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date)
			if @custdetails.present?
			  presummary = @custdetails.group(:channel).sum(:totalamt)
			#presummary =  CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date).group(:channel).sum(:totalamt)
			#@datesummary =	@custdetails.count(:group => ["DATE(orderdate)"])
			#@datesummary = @custdetails.group("DATE(orderdate)").sum(:totalamt)
			#@datesummary =  CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date).group(:orderdate).sum(:totalamt)
			# @hoursummary =  CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date).group('EXTRACT(HOUR FROM orderdate)').order('EXTRACT(HOUR from orderdate)').count.sum(:totalamt)
			 @summary = presummary.sort_by{|k,v| v}.reverse
			end

    elsif params[:ordernum].present?
           @custdetails = CUSTDETAILS.where("ordernum = ?", params[:ordernum]).order("id DESC").limit(200)     
	 end	
    respond_with(@custdetails)
  end
  

  def search
  
  end
 
  def details
  
  end
end
