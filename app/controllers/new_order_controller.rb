class NewOrderController < ApplicationController
  respond_to :html, :xml, :json
  def index
    @calledno = params[:calledno]
    @calledno = @calledno.split.join
     @force = 'no'
       if params.has_key?(:force)
              @force = params[:force]   
       end
          @medialist =  Medium.where('telephone = ?', params[:calledno])
          #time_range = (Time.now.midnight - 1.day)..Time.now.midnight
          @all_calllist = CampaignPlaylist.joins(:campaign)
          .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
            .where(campaigns: {:mediumid  => Medium.where('telephone = ?', params[:calledno]).pluck(:id) })       
           @campaign_playlists = CampaignPlaylist.where("campaignid = ?" , params[:campaignid]).order('starttime')
           
           # .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
          
           @productvariantlist = ProductVariant.where('activeid = ?',  1)
           .joins(:product_master).where("product_masters.productactivecodeid = ?", 1)
            
            @statelist = State.all
            
            
    @customer = Customer.where('mobile = ?' , params[:mobile]).last
    if @customer.blank? || @force.downcase == 'yes'
      
          @customer = Customer.new
          @order_master = OrderMaster.new
          @order_line = OrderLine.new
          @customer_address = CustomerAddress.new
          
                
         respond_with(@customer, @order_master, @order_line, @customer_address)
       else
        
         
       #render :index #show the show page with all params
       #redirect_to customers_path, :mobile => params[:mobile], :calledno => params[:called_to] #, :flash => { :error => "Existing Customer was found!" }
      
      #to redirect to another page which has history of purchases enable the below line disable the first line in the
      
       redirect_to customers_path(:mobile => params[:mobile], :calledno => params[:calledno]), :notice => "Existing Customer was found!"
       end
  end
  
  def create
    @customer = Person.new(params[:customer])
    @order_master.build_order(params[:order_master])
    if @customer.save
      redirect_to_index 'Person added successfully'
      redirect_to customers_path(:mobile => params[:mobile], :calledno => params[:calledno]), :notice => "Customer was added!"
    else
      @page_title = "Add a new person"
      @order = @customer.order_master
      render :action => 'index'
    end
  end
end
