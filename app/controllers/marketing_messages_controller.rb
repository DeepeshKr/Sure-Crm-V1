class MarketingMessagesController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_marketing_message, only: [:show, :edit, :update, :destroy]
  before_action :order_payment_mode, only: [:new, :edit, :update]
  # GET /marketing_messages
  # GET /marketing_messages.json
  def index
    @marketing_messages = MarketingMessage.all.paginate(:page => params[:page], :per_page => 100)
    
  end

  # GET /marketing_messages/1
  # GET /marketing_messages/1.json
  def show
    @message_on_orders = MessageOnOrder.where(marketing_message_id: @marketing_message.id).paginate(:page => params[:page], :per_page => 100)
  end

  # GET /marketing_messages/new
  def new
    @marketing_message = MarketingMessage.new
  end

  # GET /marketing_messages/1/edit
  def edit
  end

  # POST /marketing_messages
  # POST /marketing_messages.json
  def create
    @marketing_message = MarketingMessage.new(marketing_message_params)

    respond_to do |format|
      if @marketing_message.save
        @marketing_message.create_plan
        format.html { redirect_to @marketing_message, notice: 'Marketing message was successfully created.' }
        format.json { render :show, status: :created, location: @marketing_message }
      else
        format.html { render :new }
        format.json { render json: @marketing_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marketing_messages/1
  # PATCH/PUT /marketing_messages/1.json
  def update
    respond_to do |format|
      if @marketing_message.update(marketing_message_params)
        @marketing_message.update_plan
        if @marketing_message.activate == true
          @marketing_message.generate_messeges 
          redirect_to @marketing_message, notice: "#{@marketing_message.total_nos} Marketing messages are now queued for delivery" and return
        end
        
        format.html { redirect_to @marketing_message, notice: 'Marketing message was successfully updated.' }
        format.json { render :show, status: :ok, location: @marketing_message }
      else
        format.html { render :edit }
        format.json { render json: @marketing_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marketing_messages/1
  # DELETE /marketing_messages/1.json
  def destroy
   redirect_to marketing_messages_url, notice: 'Marketing messages sent cannot be deleted.' and return if @marketing_message.activate == true
    
    @marketing_message.destroy
    respond_to do |format|
      format.html { redirect_to marketing_messages_url, notice: 'Marketing message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def order_payment_mode
      set_modes = [10000, 10080, 10001, 10102, 10101, 10060, 10100]
      @order_paymentmodes = Orderpaymentmode.where(id: set_modes)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_marketing_message
      @marketing_message = MarketingMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketing_message_params
      params.require(:marketing_message).permit(:name, :description, :total_nos, :activate, :start_date, :end_date, :order_paymentmodeid)
    end
end
