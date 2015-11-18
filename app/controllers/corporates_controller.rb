class CorporatesController < ApplicationController
  include TransferOrders
  before_action :set_corporate, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
  
      if params.has_key?(:search) 
         @search = "Search for " +  params[:search].upcase
          @searchvalue = params[:search].upcase   
         @corporates = Corporate.where("name like ? OR city like ? or state like ?", "#{@searchvalue}%",
       "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])
      respond_with(@corporates)
      else
         @corporates = Corporate.all.paginate(:page => params[:page])
      respond_with(@corporates)
      end
     
  end
 
  def show
    #show pincode
    @distributor_pincode_lists = DistributorPincodeList.where(corporate_id: @corporate.id).paginate(:page => params[:page]) 
    #.sort("pincode, name")
    @corporate_id = @corporate.id
    #add pincode
    @distributor_pincode_list = DistributorPincodeList.new(corporate_id: @corporate.id)
    
    #show distributor stock summary
    @distributor_stock_summaries = DistributorStockSummary.all.where(corporate_id: @corporate.id)

    #show stock ledger
     @distributor_stock_ledgers = DistributorStockLedger.all.where(corporate_id: @corporate.id).order("ledger_date DESC").limit(100)

     #add stock ledger
    @product_list = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").order('product_lists.name') #.limit(10)
    @product_master = ProductMaster.where(productactivecodeid: 10000).order('name') #.limit(10)
    @distributor_stock_ledger_type = DistributorStockLedgerType.order('sort_order')
    @distributor_stock_ledger = DistributorStockLedger.new(corporate_id: @corporate.id) #
    @distributor_missed_orders = DistributorMissedOrder.where(corporate_id: @corporate.id).order("id DESC").limit(100)
    india_pincode_lists = IndiaPincodeList.take(0)

    respond_with(@corporate)
  end

  def createnew

    @india_pincode_lists = IndiaPincodeList.take(0)
     
    @corporate = Corporate.new
    respond_with(@corporate)
  end

  def show_pincode_list
    #http://pullmonkey.com/2012/08/11/dynamic-select-boxes-ruby-on-rails-3/
     #if media_tapes.present?
    @searchvalue = params[:searchvalue]
    @searchvalue =  @searchvalue.upcase

   # @india_pincode_lists = IndiaPincodeList.where("UPPER(divisionname) like ? OR UPPER(pincode) like ? OR UPPER(districtname) like ? OR UPPER(regionname) like ? OR UPPER(taluk) like ? OR UPPER(circlename) like ? OR UPPER(statename) like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
    @india_pincode_lists = IndiaPincodeList.where("UPPER(divisionname) like ? OR UPPER(pincode) like ? OR UPPER(districtname) like ? OR UPPER(regionname) like ? OR UPPER(taluk) like ? OR UPPER(circlename) like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")

    @india_pincode_lists = @india_pincode_lists.order(:pincode)
    @india_pincode_lists = @india_pincode_lists.map{|s| [s.details, s.pincode]}

    #render json: @india_pincode_lists
  end
  def add
    @corporate = Corporate.new
    unless @corporate.valid?
     flash[:error] = @corporate.errors.full_messages.join(" ")
     redirect_to :action => 'createnew'
       else
         flash[:success] = "Corporate added successfully"   
        #  @corporate = Corporate.new(corporate_params)
        #@corporate.save
        respond_with(@corporate)
       end
   
    
    #redirect_to :action => 'index'
  end

  def new
    @corporate = Corporate.new
    respond_with(@corporate)
  end

  def edit
  end

  def transfer_order
    if params.has_key?(:order_id)
      flash[:notice] = check_transfer(params[:order_id])
      @order_id
    end
  end

  def create
    @corporate = Corporate.new(corporate_params)
    if @corporate.valid?
          flash[:success] = "Distributor successfully added " 
            @corporate.save
           
      else
          flash[:error] = @corporate.errors.full_messages.join("<br/>")
      end
   
    respond_with(@corporate)
  end

  def update
    @corporate.update(corporate_params)
    if @corporate.valid?
          flash[:success] = "Distributor successfully added " 
            @corporate.save
           
      else
          flash[:error] = @corporate.errors.full_messages.join("<br/>")
      end
    respond_with(@corporate)
  end

  def destroy
    @corporate.destroy
    respond_with(@corporate)
  end

  private
    def set_corporate
      @corporate = Corporate.find(params[:id])
    end

    def corporate_params
      params.require(:corporate)
      .permit(:name, :address1, :address2, :address3, 
        :landmark, :city, :pincode, :state, :district, 
        :country, :telephone1, :telephone2, :fax, 
        :website, :salute1, :first_name1, :last_name1, 
        :designation1, :mobile1, :emaild1, :salute2, 
        :first_name2, :last_name2, :designation2, 
        :mobile2, :emailid2, :salute3, :first_name3, 
        :last_name3, :designation3, :mobile3, 
        :emailid3, :description, :corporate_type_id,
        :active, :tally_id,  :c_form, 
        :cst_no, :gst_no, :vat_no, :tin_no, :rupee_balance, 
        :web_id, :ref_no, :commission_percent, :pan_card_no)
      #:commission_percent, :decimal, precision: 4, scale: 5
    end
    def add_all

      # @address_dealer = ADDRESS_DEALER.all

       # @address_dealer.each do |dealer|
       #  @corporate = Corporate.new(name: dealer.franchisee,
       #    :address1 => dealer.add1, 
       #    :address2 => dealer.add2, 
       #    :address3 => dealer.add3,  
       #   :state => dealer.state,
       #   :country => "India", 
       #   :telephone1 => dealer.phone, 
       #   :telephone2 => dealer.mobile, 
       #   :fax => dealer.fax)
       #   @corporate.save
       # end
    end
end
