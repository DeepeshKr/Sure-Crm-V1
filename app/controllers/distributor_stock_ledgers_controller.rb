class DistributorStockLedgersController < ApplicationController
  before_action :set_distributor_stock_ledger, only: [:show, :edit, :update, :destroy]

  # GET /distributor_stock_ledgers
  # GET /distributor_stock_ledgers.json
  def index
    if params.has_key?(:corporate_id)
      @btn1 = "btn btn-default"
      @btn2 = "btn btn-default"
      @btn3 = "btn btn-default"
      @corporate = Corporate.find(params[:corporate_id])
       @distributor_stock_ledgers = DistributorStockLedger.where(corporate_id: params[:corporate_id]).order("ledger_date DESC").paginate(:page => params[:page], :per_page => 100)
       if params.has_key?(:type_id)
         @distributor_stock_ledgers =  @distributor_stock_ledgers.where(type_id: params[:type_id]).order("ledger_date DESC").paginate(:page => params[:page], :per_page => 100)
        status = params[:type_id].to_i
        case status # a_variable is the variable we want to compare
          when 10000    #compare to 1
            @btn1 = "btn btn-success"
            @message_details = "Showing MIS Entries"
          when 10001    #compare to 2
            @btn2 = "btn btn-success"
             @message_details = "Showing all Purchases"
          when 10002
           @btn3 = "btn btn-success"
            @message_details = "Showing all Sold to Customer"
          else
            @message_details = "Wrong Selection made"
        end

       end
     else
      @distributor_stock_ledgers = DistributorStockLedger.order("ledger_date DESC").limit(100).paginate(:page => params[:page], :per_page => 100)
     end


  end

  # GET /distributor_stock_ledgers/1
  # GET /distributor_stock_ledgers/1.json
  def show
    @distributor_stock_book = DistributorStockBook.find(params[:id])
  end

  # GET /distributor_stock_ledgers/new
  def new
    @all_product_list = DistributorProductList.all.pluck(:product_list_id)
    @product_list = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").where('id IN (?)', @all_product_list).order('product_lists.name') #.limit(10)
    if params.has_key?(:corporate_id)
      @corporate_id = params[:corporate_id]
    elsif distributor_stock_ledger_params.has_key?(:corporate_id)
      @corporate_id = distributor_stock_ledger_params[:corporate_id]
    end
    @corporate = Corporate.find(@corporate_id)
      #@product_master = ProductMaster.where(productactivecodeid: 10000) #.limit(10).order('name')
    @distributor_stock_ledger_type = DistributorStockLedgerType.order('sort_order')
    @distributor_stock_ledger = DistributorStockLedger.new(corporate_id: @corporate_id)
  end

  # GET /distributor_stock_ledgers/1/edit
  def edit
  end

  # POST /distributor_stock_ledgers
  # POST /distributor_stock_ledgers.json
  def create
    #on create change update stock summary
    @distributor_stock_ledger = DistributorStockLedger.new(distributor_stock_ledger_params)

    respond_to do |format|
      if @distributor_stock_ledger.save

        #update_product_details(@distributor_stock_ledger.id)

        format.html { redirect_to corporate_path @distributor_stock_ledger.corporate_id, notice: 'Distributor stock ledger was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_stock_ledger }
      else
        format.html { render :new }
        format.json { render json: @distributor_stock_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_stock_ledgers/1
  # PATCH/PUT /distributor_stock_ledgers/1.json
  def update
    #on create change update stock summary
    respond_to do |format|
      if @distributor_stock_ledger.update(distributor_stock_ledger_params)
        format.html { redirect_to corporate_path @distributor_stock_ledger.corporate_id, notice: 'Distributor stock ledger was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_stock_ledger }
      else
        format.html { render :edit }
        format.json { render json: @distributor_stock_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_stock_ledgers/1
  # DELETE /distributor_stock_ledgers/1.json
  def destroy
    @distributor_stock_ledger.destroy
    respond_to do |format|
      format.html { redirect_to corporate_path @distributor_stock_ledger.corporate_id, notice: 'Distributor stock ledger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_stock_ledger
      @distributor_stock_ledger = DistributorStockLedger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_stock_ledger_params
      params.require(:distributor_stock_ledger).permit(:corporate_id,
        :product_master_id,
        :product_variant_id,
        :product_list_id, :prod, :name,
        :description, :stock_change, :stock_value, :ledger_date,
        :type_id)
    end


  #   def update_product_details(distributor_stock_ledger_id)
  #      distributor_stock_ledger = DistributorStockLedger.find(distributor_stock_ledger_id)
  #
  #     # corporate_type_ids = distributor_stock_ledger.corporate.corporate_type_id
  #     # if ['10021', '10020'].include?('corporate_type_ids') #corporate.corporate_type_id
  #
  #       if distributor_stock_ledger.product_list_id.present?
  #         #product list details from product master id
  #         product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
  #         if product_list.present?
  #           #product list details from product master id
  #           #distributor_stock_ledger = DistributorStockLedger.find(self.id)
  #           distributor_stock_ledger.update(product_master_id: product_list.product_master_id,
  #             product_variant_id: product_list.product_variant_id,
  #             prod: product_list.extproductcode)
  #           #product variant details from product master id
  #           if distributor_stock_ledger.type_id != 10000 #stock change
  #              flash[:error] = "Ledger details #{distributor_stock_ledger.type_id}"
  #
  #               #update_product_stock_summary(distributor_stock_ledger_id)
  #           end
  #         end
  #       elsif distributor_stock_ledger.type_id == 10000 #mis additions
  #               update_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value)
  #                flash[:error] = "Corporate MIS Balance updated by #{distributor_stock_ledger.stock_value}"
  #       end
  #
  #   # else
  #   #   comments = distributor_stock_ledger.description + " No changes can be done to a regular distribuor"
  #   #   distributor_stock_ledger.update(description: comments)
  #   # end
  #   end
  #   def update_corporate_mis_balance(corporate_id, mis_value)
  #
  #      corporate = Corporate.find(corporate_id)
  #      fin_value = corporate.rupee_balance ||= 0 #if corporate.rupee_balance.present?
  #      #flash[:notice] = "Corporate MIS Balance #{fin_value} updating to #{mis_value}"
  #      fin_value += mis_value
  #      corporate.update(rupee_balance: fin_value)
  #
  #   end
  #
  #   def update_product_stock_summary(distributor_stock_ledger_id)
  #     distributor_stock_ledger = DistributorStockLedger.find(distributor_stock_ledger_id)
  #   todaydate = (330.minutes).from_now.to_date
  #   if distributor_stock_ledger.type_id != 10000
  #     if distributor_stock_ledger.product_list_id.present?
  #       #product list details from product master id
  #       product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
  #       if product_list.present?
  #         #product list details from product master id
  #          if DistributorStockSummary.where("product_list_id = ? and corporate_id = ?",distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).present?
  #
  #            distributor_stock_summary = DistributorStockSummary.where("product_list_id = ? and corporate_id = ?",distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).first
  #         #   #get current balance
  #            balance_qty = distributor_stock_summary.stock_qty
  #            balance_val = distributor_stock_summary.stock_value
  #         #   #if self.type_id == 10001 #Add
  #            balance_qty += distributor_stock_ledger.stock_change
  #            balance_val += distributor_stock_ledger.stock_value
  #         #   #elsif self.type_id == 10002 #Remove
  #         #   # balance -= self.stock_change
  #         #   #end
  #
  #            distributor_stock_summary.update(product_master_id: product_list.product_master_id,
  #            product_variant_id: product_list.product_variant_id,
  #            prod: product_list.extproductcode,
  #            summary_date: distributor_stock_ledger.ledger_date,
  #            stock_qty: balance_qty, stock_value: balance_val)
  #
  #          else
  #
  #           DistributorStockSummary.create(product_list_id: distributor_stock_ledger.product_list_id,
  #           product_variant_id: distributor_stock_ledger.product_variant_id,
  #           product_master_id: distributor_stock_ledger.product_master_id,
  #           prod: distributor_stock_ledger.prod,
  #           corporate_id: distributor_stock_ledger.corporate_id,
  #           summary_date: distributor_stock_ledger.ledger_date,
  #           stock_qty: distributor_stock_ledger.stock_change,
  #           stock_value: distributor_stock_ledger.stock_value,
  #           stock_returned: 0)
  #
  #         end
  #       end
  #     end
  #   end
  # end
end
