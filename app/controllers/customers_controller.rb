class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :get_variables, only: [:new, :edit, :create]

  respond_to :html

  def index
    if params[:mobile].present?
      # @customers = Customer.all
      @customers = Customer.where('mobile = ?' ,params[:mobile])
      @calledno = params[:calledno]
      @mobile =  params[:mobile]


      respond_with(@customers, :mobile => params[:mobile], :calledno => params[:calledno], :force => 'yes')
    else
      @customers = Customer.limit(5).reorder('id desc') #, :notice => "Showing recent 5 customers!"
    end
  end

  def show
   interaction_dropdowns
    @calledno = params[:calledno]
    @order_master = OrderMaster.new
    @order_master.customer_id = params[:id]
    
    @order_masters =  OrderMaster.where(customer_id:params[:id])
    @interaction_masters =  InteractionMaster.where(customer_id:params[:id])
    @interaction_master = InteractionMaster.new(customer_id: params[:id], interaction_status_id: 10000)
    respond_with(@customer, @order_master, @order_masters, @interaction_masters, @interaction_master)
  end

  def update_customer
   @customer = Customer.find(params[:customer_id])
  orderid = params[:order_id]
 #@customer.update(customer_params)
    #respond_with(@customer)
  # @customerup = Customer.find(params[:customer_id])
    @customer.update_columns(salute: customer_params[:salute], 
      first_name: customer_params[:first_name], 
      last_name: customer_params[:last_name])
    name =  @customer.salute << " " << @customer.first_name << " " << @customer.last_name
     
    
        flash[:success] = "Customer Details were was updated successfully. #{name}" 
    
    #respond_with(@customer)
    redirect_to orderreview_path(:order_id => params[:order_id]) 
  end

  def new
    @calledno = params[:calledno]
      @customer = Customer.where('mobile = ?' , params[:mobile])
       if @customer.blank? || @force.downcase == 'yes'

          @customer = Customer.new
          @customer.mobile = @mobile
          @order_master =  @customer.order_master.build
          @order_master.calledno = @calledno
          @order_line = @order_master.order_line.build

       else
          redirect_to customers_path(:mobile => params[:mobile], :calledno => params[:calledno]), :notice => "Existing Customer was found!"
       end

  end

  def edit

           @order_master =  @customer.order_master.build
          @order_master.calledno = @calledno
           @order_line = @order_master.order_line.build
  end

  def create
    
    @customer = Customer.new(customer_params)
    respond_with(@customer) do |format|
      if @customer.save
        flash[:notice] = "order was created successfully."   
      else
         flash[:error] = @customer.errors.full_messages.join("<br/>")
      end
     
    end
  end  



  def update
     @customer = Customer.find(params[:customer_id])
    @customer.update(customer_params)
    respond_with(@customer)
  end

  def destroy
    @customer.destroy
    respond_with(@customer)
  end

  private
    def get_variables
        @empcode = current_user.employee_code
        @empid = current_user.id
        @calledno = params[:calledno]
        @force = 'no'
             if params.has_key?(:force)
                    @force = params[:force]   
             end
        dropdownlist
       @mobile = params[:mobile]
    end

    def interaction_dropdowns
        @interactioncategorylist =  InteractionCategory.where("sortorder >= 10")
        @interactionprioritylist =  InteractionPriority.all
    end 

    def dropdownlist

        @calledno = params[:calledno]
        #@calledno = @calledno.squish
            
       @medialist =  Medium.where('telephone = ?', @calledno)

       @campaignlist =  Campaign.joins(:medium).where('media.telephone = ?', @calledno)
            #time_range = (Time.now.midnight - 1.day)..Time.now.midnight
       @all_calllist = CampaignPlaylist.joins(:campaign)
           .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
           .where({campaignid: @campaignlist})
            # @campaign_playlists = CampaignPlaylist.where("campaignid = ?" , params[:campaignid]).order('starttime')
             # .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
        
             @productvariantlist = ProductVariant.where('activeid = ?',  1)
             .joins(:product_master).where("product_masters.productactivecodeid = ?", 1)
              
            #  @statelist = Medium.all
    end

    def interactions(refcatid)
     @intearaction_master = InteractionMaster.create(createdon: Time.now, interaction_status_id:1,
          customer_id: @customer.id, callednumber: @order_master.calledno,interaction_category_id:refcatid, 
          product_variant_id: @product_variant_id, orderid: @order_master.id, interaction_priority_id:1,
          campaign_playlist_id: @order_master.campaign_playlist_id, state: customer_params[:state],
          resolveby: 2.days.from_now)
          if customer_params[:comments].present?
             @interaction_transcripts = InteractionTranscript.create(interactionid:@intearaction_master.id,
             description:customer_params[:comments], interactionuserid:1, callednumber:calledno)
          end
         
    end

    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:salute, :first_name, :last_name, :mobile, 
      :alt_mobile, :emailid, :alt_emailid,  :mismatched_campaign, :comments, 
      order_master_attributes:[:id, :customer_id, :media_id,  :campaign_playlist_id, :calledno,
       order_line_attributes:[:id, :order_id, :productvariantid, :pieces]])
    end
    
  

end