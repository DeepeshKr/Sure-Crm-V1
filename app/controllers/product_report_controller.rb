class ProductReportController < ApplicationController
	before_action :get_variables, only: [:list, :search, :details]
	before_action :dropdowns, only: [:list, :search, :details]
	respond_to :html

  def list
  #prod=TOTS&from_date=02%2F24%2F2015&to_date=02%2F23%2F2015
  @type = "Sold "
	#new product stock
	#@product_stock = ProductStock.new
	#new stock adjusts
	#@product_stock_adjust = ProductStockAdjust.new(change_stock: 1)
	   
	if params[:prod].present? && params[:from_date].present? && params[:to_date].present?
	  prod = params[:prod]
	  
	  @or_from_date = params[:from_date]
	  @or_to_date = params[:to_date]
	  
	  from_date = Time.strptime(params[:from_date], '%m/%d/%Y')
	  to_date = Time.strptime(params[:to_date], '%m/%d/%Y')
	  @product_master_id = @productmasterlist.where(extproductcode: prod).first.id
	  @prod = prod
	  @from_date = from_date.to_formatted_s(:rfc822)
	  @to_date =  to_date.to_formatted_s(:rfc822)
	  
	  #Opening Stock level on date
	  @product_stocks = ProductStock.where(ext_prod_code: prod).where("TRUNC(checked_date) >= ? and TRUNC(checked_date) <= ?", from_date, to_date)
	   if @product_stocks.present?
		  #code
		  @opening_stock = @product_stocks.sum(:current_stock)
	   end
	   #new product stock
	   @product_stock = ProductStock.new(product_master_id: @product_master_id, ext_prod_code: prod, emp_code: @empcode, emp_id: @empid)
		# params.require(:product_stock).permit(:product_master_id, :product_list_id, :current_stock, :ext_prod_code, :barcode, :checked_date, :emp_code, :emp_id)
	   
	  #Stock Journal Entries (Related to returns /  damages / written off etc)
	  @product_stock_adjusts = ProductStockAdjust.where(ext_prod_code: prod).where("TRUNC(created_date) >= ? and TRUNC(created_date) <= ?", from_date, to_date)
	   if @product_stock_adjusts.present?
		  #code
		  @journal_total = @product_stock_adjusts.sum(:change_stock)
	   end
	   #new stock adjusts
	   @product_stock_adjust = ProductStockAdjust.new(product_master_id: @product_master_id, ext_prod_code: prod, emp_code: @empcode, emp_id: @empid)
	   #params.require(:product_stock_adjust).permit(:product_master_id, :product_list_id, :change_stock, :ext_prod_code, :barcode, :created_date, :emp_code, :emp_id, :name, :description)
	  #purchases
	  @purchases_new = PURCHASES_NEW.where(prod: prod).where("TRUNC(rdate) >= ? and TRUNC(rdate) <= ?", from_date, to_date)
		if @purchases_new.present?
		  #Purchases
		  @purchasesshortqty = @purchases_new.sum(:shortqty)
		  #total
			@purchasestotal = @purchases_new.sum(:invamt)
		  #pieces
		   @purchasespieces = @purchases_new.sum(:qty)
		end
  
	  #retails sales based on paid date
	  if params[:paid].present?   
		  if params[:paid] = "yes"
			  #code
			  @paid = "yes"
			  @type = "Paid "
			  @vpp = VPP.where(prod: prod).where("TRUNC(paiddate) >= ? and TRUNC(paiddate) <= ?", from_date, to_date)	
		  end
	  else
			  @type = "Sold "
			  @vpp = VPP.where(prod: prod).where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date)
	  end
  
	  if @vpp.present?
		  #Retail Sales
		  #total
		  @retailsalestotal = @vpp.sum(:paidamt)
		  #pieces
		   @retailsalespieces = @vpp.sum(:quantity)
			 presummary = @vpp.group(:despatch).sum(:paidamt)
			@summary = presummary.sort_by{|k,v| v}.reverse
			#total courier
		  @retailcouriersalestotal = @vpp.where.not(despatch: "EPP").sum(:paidamt)
		  #pieces
		   @retailcouriersalespieces = @vpp.where.not(despatch: "EPP").sum(:quantity)
  
			  #total india post
		  @retailpostsalestotal = @vpp.where(despatch: "EPP").sum(:paidamt)
		  #pieces
		   @retailpostsalespieces = @vpp.where(despatch: "EPP").sum(:quantity)
  
	  end
	  
	  #wholesale sales
	  @newwlsdet = NEWWLSDET.where(prod: prod).where("TRUNC(shdate) >= ? and TRUNC(shdate) <= ?", from_date, to_date)
		if @newwlsdet.present?
		  ##wholesale Sales
		  #total
		  @wholesalestotal = @newwlsdet.sum(:totamt)
		  #pieces
		  @wholesalespieces = @newwlsdet.sum(:quantity)
		end
  
	  #Branch Transfers
	  @tempinv_newwlsdet = TEMPINV_NEWWLSDET.where(prod: prod).where("TRUNC(shdate) >= ? and TRUNC(shdate) <= ?", from_date, to_date)
		if @tempinv_newwlsdet.present?
		  ##wholesale Sales
		  #total
		  @branchsalestotal = @tempinv_newwlsdet.sum(:totamt)
		  #pieces
		  @branchsalespieces = @tempinv_newwlsdet.sum(:quantity)
		end
	
	else
	#show recent 10 entries 
	@product_stock_adjusts = ProductStockAdjust.limit(10)
	@purchases_new = PURCHASES_NEW.limit(10)
	if @purchases_new.present?
		  #Purchases
		  @purchasesshortqty = @purchases_new.sum(:shortqty)
		  #total
			@purchasestotal = @purchases_new.sum(:invamt)
		  #pieces
		   @purchasespieces = @purchases_new.sum(:qty)
		end
	@vpp = VPP.limit(10)
		  #total
		  @retailsalestotal = @vpp.sum(:paidamt)
		  #pieces
		   @retailsalespieces = @vpp.sum(:quantity)

	@newwlsdet = NEWWLSDET.limit(10)

		 #total
		  @wholesalestotal = @newwlsdet.sum(:totamt)
		  #pieces
		  @wholesalespieces = @newwlsdet.sum(:quantity)

	@tempinv_newwlsdet = TEMPINV_NEWWLSDET.limit(10)

		  #total
		  @branchsalestotal = @tempinv_newwlsdet.sum(:totamt)
		  #pieces
		  @branchsalespieces = @tempinv_newwlsdet.sum(:quantity)
	end

  end
    
  def search

  end

  def details

  end
  	def opening_stock_report
	  	@reportname = "Opening Stock Report"
	  	if params[:prod].present? && params[:for_date].present? 
		  @or_for_date = params[:for_date]		  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name

			   #Opening Stock level on date
		  	@product_stocks = ProductStock.where(ext_prod_code: @prod).where("(checked_date) = ?", for_date)
		   if @product_stocks.present?
			  #code
			  @opening_stock = @product_stocks.sum(:current_stock)

			  	respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"opening-stock-report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end

		   end
		 
		end
	end

	def purchased_stock_report
		@reportname = "Purchased Stock Report"
	  	if params[:prod].present? && params[:for_date].present? 
		  @or_for_date = params[:for_date]		  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name

		   #purchases
		  	@purchases_new = PURCHASES_NEW.where(prod: @prod).where("(rdate) = ?", for_date)
			if @purchases_new.present?
			  #Purchases
			  @purchasesshortqty = @purchases_new.sum(:shortqty)
			  #total
				@purchasestotal = @purchases_new.sum(:invamt)
			  #pieces
			   @purchasespieces = @purchases_new.sum(:qty)

			   #view format start
			   respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"purchased_stock_report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end
          		#format end
			end
	  
		 
		end
	end

	def retail_returned_stock_report
			@reportname = "Retail Returned Report"
	  	if params[:prod].present? && params[:for_date].present? 
		 @or_for_date = params[:for_date]		  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name

		   #retails retuned
		  	@vpp = VPP.where(prod: @prod).where("returndate = ?", for_date)
			if @vpp.present?
			   #total
			  @retailsalestotal = @vpp.sum(:invoiceamount)
			  #pieces
			   @retailsalespieces = @vpp.sum(:quantity)

			   #view format start
			   respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"retail_returned_stock_report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end
          		#format end
			end
		 
		end
	end

	def retail_sold_stock_report
			@reportname = "Retail Sales Report"
	  	if params[:prod].present? && params[:for_date].present? 
		 	  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name
	
		   #retail sales
		  	@vpp = VPP.where(prod: @prod).where("(orderdate) = ?",for_date)
			if @vpp.present?
			   #total
			  @retailsalestotal = @vpp.sum(:paidamt)
			  #pieces
			   @retailsalespieces = @vpp.sum(:quantity)
			   #view format start
			   respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"retail_sold_stock_report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end
          		#format end
			end
		 
		end
	end

	def wholesale_sold_stock_report
			@reportname = "Wholesale Sales Report"
	  	if params[:prod].present? && params[:for_date].present? 
		 @or_for_date = params[:for_date]		  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name

		   #Sold wholesale
      	@newwlsdet = NEWWLSDET.where(prod: @prod).where("(shdate) = ? ", for_date)
			if @newwlsdet.present?
				#total
			  	@wholesalestotal = @newwlsdet.sum(:totamt)
			  	#pieces
			  	@wholesalespieces = @newwlsdet.sum(:quantity)

			  	 #view format start
			   	respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"wholesale_sold_stock_report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end
          		#format end
			end
		 
		end
	end

	def branch_sold_stock_report
		@reportname = "Branch Sales Report"
	  	if params[:prod].present? && params[:for_date].present? 
		 @or_for_date = params[:for_date]		  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name

			#Sold branch
			@tempinv_newwlsdet = TEMPINV_NEWWLSDET.where(prod: @prod).where("(shdate) = ? ", for_date)
			if @tempinv_newwlsdet.present?
				 #total
			  @branchsalestotal = @tempinv_newwlsdet.sum(:totamt)
			  #pieces
			  @branchsalespieces = @tempinv_newwlsdet.sum(:quantity)

			   #view format start
			   	respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"branch_sold_stock_report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end
          		#format end
			end
		 
		end
	end

	def corrections_stock_report
		@reportname = "Journal Report"
	  	if params[:prod].present? && params[:for_date].present? 
		  @or_for_date = params[:for_date]		  
		  @prod = params[:prod]
		  for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
		  @for_date = for_date.strftime('%d-%b-%y')
		  @product_master_name = ProductMaster.where(extproductcode: @prod).first.name

		   #stock adjust journal
		  	@product_stock_adjusts = ProductStockAdjust.where(ext_prod_code: @prod).where("(created_date) = ?", for_date) 
		  	if @product_stock_adjusts.present?
		  		#code
		  		@journal_total = @product_stock_adjusts.sum(:change_stock)

		  		#view format start
			   	respond_to do |format|
		            format.html
		            format.csv do
		              headers['Content-Disposition'] = "attachment; filename=\"corrections_stock_report\""
		              headers['Content-Type'] ||= 'text/csv'
		            end
          		end
          		#format end
          		
		  	end	 
		end
	end


  private
    def dropdowns
        @productmasterlist = ProductMaster.all
    end
    def get_variables
    	@empcode = current_user.employee_code
        @empid = Employee.where(employeecode: @empcode).first.id
        @productmaster_id = params[:productmaster_id]
        @from_date = params[:from_date]
        @to_date = params[:to_date]   
    end
end