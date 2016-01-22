class CorporatesController < ApplicationController
  before_action { protect_controllers(6) }
  include TransferOrders
  #include ProductPricing
  before_action :set_corporate, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @corporate_types = CorporateType.all
      if params.has_key?(:search)
         @search = "Search for " +  params[:search].upcase
          @searchvalue = params[:search].upcase

            #Super Distributor 10020
         @supercorporates = Corporate.where(corporate_type_id: 10020).where("UPPER(name) like ? OR UPPER(city) like ? or UPPER(state) like ?", "#{@searchvalue}%",
       "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])
       #Transfer Order Distributor 10021
       @transferordercorporates = Corporate.where(corporate_type_id: 10021).where("UPPER(name) like ? OR UPPER(city) like ? or UPPER(state) like ?", "#{@searchvalue}%",
     "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])
     #REgular Distributor
      @regularcorporates = Corporate.where(corporate_type_id: 10000).where("UPPER(name) like ? OR UPPER(city) like ? or UPPER(state) like ?", "#{@searchvalue}%",
   "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])
   #Others Distributor
    @corporates = Corporate.where("corporate_type_id IS NULL").where("UPPER(name) like ? OR UPPER(city) like ? or UPPER(state) like ?", "#{@searchvalue}%",
 "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])


      else
        #Super Distributor
        @supercorporates = Corporate.where(corporate_type_id: 10020).order(:updated_at).paginate(:page => params[:page])
        #Transfer Order Distributor
        @transferordercorporates = Corporate.where(corporate_type_id: 10021).order(:updated_at).paginate(:page => params[:page])
        #REgular Distributor
         @regularcorporates = Corporate.where(corporate_type_id: 10000).order(:updated_at).paginate(:page => params[:page])

         #Others Distributor
          @corporates = Corporate.where("corporate_type_id IS NULL").order(:updated_at).paginate(:page => params[:page])



      end
      @distributor_upload_order = DistributorUploadOrder.first
  end
  #
  # def list_type
  #   if params.has_key(:corporate_type_id)
  #   params[:page]
  #
  #   else
  #     return redirect_to corporates_path
  #   end
  # end

  def show
    #show pincode
    @distributor_pincode_lists = DistributorPincodeList.where(corporate_id: @corporate.id).paginate(:page => params[:page])
    @distributor_pincode_list_nos = DistributorPincodeList.where(corporate_id: @corporate.id).count
    #.sort("pincode, name")
    @corporate_id = @corporate.id
    #add pincode
    @distributor_pincode_list = DistributorPincodeList.new(corporate_id: @corporate.id,sort_order: 1)


    #show distributor stock summary
    @distributor_stock_summaries = DistributorStockSummary.all.where(corporate_id: @corporate.id)

    #show stock ledger
     @distributor_stock_ledgers = DistributorStockLedger.all.where(corporate_id: @corporate.id).order("created_at DESC, ledger_date DESC").limit(10)

     #add stock ledger
    @product_list = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").order('product_lists.name') #.limit(10)
    #@product_master = ProductMaster.where(productactivecodeid: 10000).order('name') #.limit(10)
    @distributor_stock_ledger_type = DistributorStockLedgerType.order('sort_order')
    @distributor_stock_ledger = DistributorStockLedger.new(corporate_id: @corporate.id) #
    @distributor_missed_orders = DistributorMissedOrder.where(corporate_id: @corporate.id).order("id DESC").limit(10)
    india_pincode_lists = IndiaPincodeList.take(0)

    chkuser = User.where(employee_code: @corporate.id)
     #@addnewlogin = false
     @addnewlogin = true || false if chkuser.present?
    if chkuser.present?
      @userpas = chkuser.first
      @userstatus = "#{chkuser.first.name} has already got a Login Id: #{chkuser.first.employee_code} and password, you may change the password here"
   else
     emailid = @corporate.emaild1 || nil if @corporate.emaild1.present?
     @user = User.new(name: @corporate.name, employee_code: @corporate.id,
      email: emailid, role: 10141) #distributor role id
      @userstatus = "This distributor has does not have Login Id"
    end
    #@corporate
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
    # t.integer :order_id
    # t.integer :ext_order_id
    # t.datetime :last_ran_on
    # t.text :description
    # t.integer :online_order_id
    # t.datetime :online_last_ran_on
    # t.text :online_description
    @distributor_upload_order = DistributorUploadOrder.first

    if params.has_key?(:order_id)
      @order_id = params[:order_id]
      flash[:notice] = check_transfer(@order_id)
    end
  end

  def transfer_order_pricing
    @states = State.all.order("name")
    @productlist = ProductList.all.order("name")
    @transfer_order_pricing = nil
    if params.has_key?(:product_code)
      @state = nil
      @product_code = params[:product_code]
       if params.has_key?(:state)
          @state = params[:state]
       end
       @transfer_order_pricing = wholesale_price(@product_code, @state)
      flash[:notice] = "Checked Transfer order pricing for product #{@product_code} in state #{@state}"

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
