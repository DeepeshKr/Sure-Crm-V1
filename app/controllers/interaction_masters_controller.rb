class InteractionMastersController < ApplicationController
  before_action :set_interaction_master, only: [:show, :new_ticket, :edit, :update, :destroy, :dealer_enquiry]


  respond_to :html

  def index
    @categoryid = params[:category]
   
    @category =  InteractionCategory.all
    if @categoryid.present?
      @interaction_masters = InteractionMaster.where("interaction_category_id = ?", params[:category])
       @category_name = InteractionCategory.find(params[:category]).name

      respond_with(@interaction_masters)

    else
       @category_name = "Select any category"
    end

    
  end

  def show
    
    @interaction_status = InteractionStatus.all
    @em_interaction_transcript = InteractionTranscript.new(:interactionid => params[:id], :interactionuserid => 10001)
    @cm_interaction_transcript = InteractionTranscript.new(:interactionid => params[:id], :interactionuserid => 10000)
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
    
      dropdowns
    #'this is get'
      customer_id = params[:customer_id]
      @customer = Customer.find(customer_id)
      @interaction_master = InteractionMaster.new(interaction_status_id: 10000, 
        customer_id: customer_id)
      flash[:error] = "Customer Id is missing!" 
      respond_with(@interaction_master, @customer)

    
      
    
  end

  def create
    @interaction_master = InteractionMaster.new(interaction_master_params)
    @interaction_master.save
    respond_with(@interaction_master)
  end
# interaction_masters
#  Name            Null?    Type
#  ----------------------------------------- -------- ----------------------------
#  ID            NOT NULL NUMBER(38)
#  CREATEDON              DATE
#  CLOSEDON             DATE
#  RESOLVEBY              DATE
#  INTERACTION_STATUS_ID            NUMBER(38)
#  CUSTOMER_ID              NUMBER(38)
#  CALLEDNUMBER             VARCHAR2(255 CHAR)
#  INTERACTION_CATEGORY_ID          NUMBER(38)
#  PRODUCT_VARIANT_ID           NUMBER(38)
#  ORDERID              NUMBER(38)
#  INTERACTION_PRIORITY_ID          NUMBER(38)
#  CAMPAIGN_PLAYLIST_ID           NUMBER(38)
#  NOTES                CLOB
#  STATE                VARCHAR2(255 CHAR)
#  CREATED_AT             DATE
#  UPDATED_AT             DATE

  def new_interaction
    dropdowns
   
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
    
    respond_with(@interaction_master.customer)
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

        @interactioncategorylist =  InteractionCategory.where("sortorder >= 10")
        @interactionprioritylist =  InteractionPriority.all
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
