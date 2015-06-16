class InteractionMastersController < ApplicationController
    before_action { protect_controllers(12) } 
  before_action :set_interaction_master, only: [:show, :new_ticket, :edit, :update, :destroy]


  respond_to :html

  def index
   
   
   dropdowns
    if params.has_key?(:category) and params.has_key?(:status)

       @categoryid = params[:category]
      @interaction_masters = InteractionMaster.where("interaction_category_id = ? and interaction_status_id = ?", params[:category], params[:status])
      #.joins(:interaction_status).where('interaction_statuses.sortorder < 4')
       @category_name = InteractionCategory.find(params[:category]).name
      if params[:status].present?
         @statusid = params[:status]
      end
      #respond_with(@interaction_masters)
       @category_name = "Search for Category and Status selected above"
    elsif params.has_key?(:for_date)
       for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
        @interaction_masters = InteractionMaster.where("TRUNC(INTERACTION_MASTERS.created_at) = ?", for_date).joins(:interaction_category).where('interaction_categories.sortorder > 100 and interaction_categories.sortorder < 300')
       @category_name = "Searched for order for #{for_date} and found #{@interaction_masters.count()}"
    elsif params.has_key?(:mobile)
      @mobile = params[:mobile]
      @mobile = @mobile.strip
        @interaction_masters = InteractionMaster.where(mobile: @mobile)
       @category_name = "Searched for order for mobile #{params[:mobile]} and found #{@interaction_masters.count()}"
      else
       @category_name = "Search for date / mobile or Category"
    end

    
  end
  def dealer_enquiry
      @interactioncategorylist =  InteractionCategory.where("id = 10020").order("sortorder")
      @interactionstatuslist =  InteractionStatus.all.order("sortorder")
      @category =  InteractionCategory.all
    if params.has_key?(:category)
        @categoryid = params[:category]
        @interaction_masters = InteractionMaster.where("interaction_category_id = ?", 10020)
        @category_name = InteractionCategory.find(params[:category]).name
        respond_with(@interaction_masters)
    elsif params.has_key?(:for_date)
        for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
        @interaction_masters = InteractionMaster.where("TRUNC(created_at) = ?", for_date).where("interaction_category_id = ?", 10020)
        @category_name = "Searched for order for #{for_date}"
    else
        @category_name = "Select any category"
    end
 
  end

  def show
    @empcode = current_user.employee_code
      #@empid = current_user.id
      @empid = Employee.where(employeecode: @empcode).first.id
    @interaction_status = InteractionStatus.all
    @em_interaction_transcript = InteractionTranscript.new(:interactionid => params[:id], :interactionuserid => 10001, employee_id: @empid, ip: request.remote_ip)
    @cm_interaction_transcript = InteractionTranscript.new(:interactionid => params[:id], :interactionuserid => 10000, employee_id: @empid, ip: request.remote_ip)
     @interaction_transcripts = InteractionTranscript.where("interactionid = ?", params[:id]).order(:created_at)
    respond_with(@interaction_master, @interaction_transcripts, @em_interaction_transcript, @cm_interaction_transcript)
  end

  def new
    @interaction_master = InteractionMaster.new
    respond_with(@interaction_master)
  end

  def edit
  end

  def new_ticket
    t = Time.zone.now + 330.minutes
      dropdowns
      @interaction_master = InteractionMaster.create(customer_id: params[:customer_id],
       callednumber: params[:callednumber], orderid: params[:orderid],
       interaction_category_id: params[:interaction_category_id],
       state: params[:state], mobile: params[:mobile],
       employee_id: params[:employee_id], employee_code: params[:employee_code],
       interaction_status_id: 10000, interaction_priority_id: 10000, 
       createdon: t, resolveby: t + 10.days)
        #customer_id: interaction_master_params[:customer_id], interaction_category_id: interaction_master_params[:interaction_category_id], interaction_priority_id: interaction_master_params[:interaction_priority_id]
        #@interaction_transcript = InteractionTranscript.new(interactionid: @interaction_master.id, interactionuserid: 10000, description: params[:description])
      @interaction_transcript = @interaction_master.interaction_transcript.create(interactionuserid: 10000, 
        description: params[:description], 
        employee_id: params[:employee_id],
        callednumber: params[:callednumber],
        ip: request.remote_ip )
  
    
     # if @interaction_master.interaction_category.sortorder > 100
     # mobile, description, problem, interactionid
        MailerAlerts.customer_request("vipin@telebrandsindia.com", params[:mobile], @interaction_transcript.description, @interaction_master.interaction_category.name, @interaction_master.id ).deliver_now
        MailerAlerts.customer_request("naushad@telebrandsindia.com", params[:mobile], @interaction_transcript.description, @interaction_master.interaction_category.name, @interaction_master.id ).deliver_now
        MailerAlerts.customer_request("prem@telebrandsindia.com", params[:mobile], @interaction_transcript.description, @interaction_master.interaction_category.name, @interaction_master.id ).deliver_now
        MailerAlerts.customer_request("mis@telebrandsindia.com", params[:mobile], @interaction_transcript.description, @interaction_master.interaction_category.name, @interaction_master.id ).deliver_now
        #MailerAlerts.customer_request("cronupdatedata@gmail.com", params[:mobile], @interaction_transcript.description, @interaction_master.interaction_category.name, @interaction_master.id ).deliver_now
      #end
      if params[:orderid].present?
        flash[:success] = "The order details are logged with order, you are now ready to start new call, close this window!"
          #respond_with(@interaction_master.customer)
        else
          flash[:success] = "The details are logged, you are now ready to start new call, close this window!"  
        end
    redirect_to root_path
  end

  def create
    @interaction_master = InteractionMaster.new(interaction_master_params)
    @interaction_master.save
    respond_with(@interaction_master)
  end


  def new_interaction
    dropdowns
   if params[:orderid].present?
    @interaction_master = InteractionMastercreate(customer_id: params[:customer_id],
     callednumber: params[:callednumber], orderid: params[:orderid],
     interaction_category_id: params[:interaction_category_id],
     state: params[:state], mobile: params[:mobile],
     employee_id: params[:employee_id], employee_code: params[:employee_code],
     interaction_status_id: 10000, interaction_priority_id: 10000, 
     createdon: Time.now, resolveby: Time.now + 10.days)
   #customer_id: interaction_master_params[:customer_id], interaction_category_id: interaction_master_params[:interaction_category_id], interaction_priority_id: interaction_master_params[:interaction_priority_id]
    #@interaction_transcript = InteractionTranscript.new(interactionid: @interaction_master.id, interactionuserid: 10000, description: params[:description])
    @interaction_transcript = @interaction_master.interaction_transcript(interactionuserid: 10000, description: params[:description])
   # @customer = @interaction_master.customer
    respond_with(@interaction_master.customer)  
  else
     flash[:error] = "You can report this order after some products are added or order process is midway!"
  end

  end

  def dispose_call
    dropdowns
    #Time.now + 10.days
    @interaction_master = InteractionMaster.create(customer_id: params[:customer_id],
     callednumber: params[:callednumber], orderid: params[:orderid],
     interaction_category_id: params[:interaction_category_id],
     state: params[:state], mobile: params[:mobile],
     employee_id: params[:employee_id], employee_code: params[:employee_code],
     interaction_status_id: 10003, interaction_priority_id: 10000, 
     createdon: Time.now, resolveby: Time.now,
      closedon: Time.now)
    
    if params[:orderid].present?
        flash[:success] = "The disposition is logged with order, you are now ready to start new call, close this window!"
      #respond_with(@interaction_master.customer)
    else
      flash[:success] = "The disposition is logged, you are now ready to start new call, close this window!"
      
    end
    redirect_to root_pathrect_to root_path
    
    
  end

  def update_ticket
    customer_id = params[:customer_id]
    @customer = Customer.find(customer_id)
    @interaction_master = InteractionMaster.new(interaction_master_params)
    @interaction_master.save
    respond_with(@interaction_master, @customer)
  end

  def update
    @interaction_master.update(interaction_master_params)
    respond_with(@interaction_master)
  end

  def destroy
    @interaction_master.destroy
    respond_with(@interaction_master)
  end

  private
    def set_interaction_master
      @interaction_master = InteractionMaster.find(params[:id])
    end

    def dropdowns
        # @category =  InteractionCategory.all
        @interactioncategorylist =  InteractionCategory.where("sortorder > 100").order("sortorder")
        @interactionstatuslist =  InteractionStatus.all.order("sortorder")
    end

    def interaction_master_params
      params.require(:interaction_master).permit(:createdon, :resolveby, :interaction_status_id, :customer_id, :interaction_category_id, :product_variant_id, :orderid, :interaction_priority_id, :campaign_playlist_id, :notes, :description)
    end

    def customer_params
      params.require(:customer).permit(:salute, :first_name, :last_name, :mobile, 
      :alt_mobile, :emailid, :alt_emailid, :calledno, :orderpaymentmode_id, :city, :state)
    end

    def interaction_transcript_params
      params.require(:interaction_transcript).permit(:interactionid, :interactionuserid, :description)
    end
end
