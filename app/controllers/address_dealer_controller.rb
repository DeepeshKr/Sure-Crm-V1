class AddressDealerController < ApplicationController
		respond_to :html
  def list
  	@address_dealer = ADDRESS_DEALER.all
    respond_with(@address_dealer)
  end

  def new_dealer
  	#interacton_category_id for new dealer enquiry
  @mobile = params[:mobile]
  @calledno = params[:calledno]
	@customer = Customer.new(mobile: @mobile)
	#@customer.mobile = @mobile
	@customers = Customer.where('mobile = ?' , @mobile)
	respond_with(@customer, @customers, @interaction_master)
  end

  def dealer_enquiry
    @mobile = params[:mobile]
  @calledno = params[:calledno]
  @description = params[:description]
    refcatid = 10020

  @customers = Customer.where('emailid = ?' , customer_params[:emailid])
   @customer = Customer.new(customer_params)
  if Customer.where('emailid = ?' , customer_params[:emailid]).present?
    @customer = @customers.first
    else
    @customer.save
  end
  #check if customer registered earlier based on email id
   
   

   #if customer found just create a ticket with all the description

   if !@customer.valid?
      flash[:error] = @customer.errors.full_messages.join("<br/>")
    end

   @interaction_master = InteractionMaster.create!(createdon: Time.now, 
        interaction_status_id:10000,
            callednumber: @calledno,
            interaction_category_id:refcatid, 
            customer_id: @customer.id,
             interaction_priority_id:10000,
            state: customer_params[:state], resolveby: 2.days.from_now)

    if !@interaction_master.valid?
      flash[:error] = @interaction_master.errors.full_messages.join("<br/>")
    end

    description = "Customer Name: " << customer_params[:salute] << " " <<  customer_params[:first_name] << " " << customer_params[:last_name] << "  current details " << @description << " called number " << customer_params[:mobile] << " called number " << customer_params[:alt_mobile] << "-- update by user: " << current_user.name << " from ip:" << request.remote_ip
    
    @interaction_transcript = @interaction_master.interaction_transcript.create(interactionuserid: 10000,  description: description)
   # :, :

     MailerAlerts.dealer_enquiry("deepesh@tec2grow.com", @customer, @description).deliver_now

     if !@interaction_transcript.valid?
      flash[:error] = @interaction_transcript.errors.full_messages.join("<br/>")
    end
    @interaction_transcripts =@interaction_transcript
flash[:success] = "You have create new interaction please close the window now!"
    #redirect_to interaction_masters_path(@interaction_master)
    respond_with(@interaction_master, @interaction_transcript)
  end



  def add_customer
	calledno = params[:calledno]
 	mobile = params[:mobile]
	@customer = Customer.new(customer_params)
	if @customer.save
		@order_master = OrderMaster.new(calledno: @calledno, order_status_master_id: 1, 
			orderdate: Time.now, pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, 
			total: 0, order_source_id: 1, employeecode: @empcode, employee_id: @empid, 
			customer_id: @customer.id)
		  @order_master.save(:validate => false)
        flash[:success] = "order was created successfully." 
         redirect_to showproduct_path(:order_id => @order_master.id)   
      else
         flash[:error] = @customer.errors.full_messages.join("<br/>")
         redirect_to neworder_path(:mobile => mobile, :calledno => calledno ) 
         #respond_with(@customer, @order_master)
    end
    end

private
 def customer_params
      params.require(:customer).permit(:salute, :first_name, :last_name, :mobile, 
      :alt_mobile, :emailid, :alt_emailid, :calledno, :description, :city, :state)
    end
  
end
