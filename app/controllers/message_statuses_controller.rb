class MessageStatusesController < ApplicationController
  before_action :set_message_status, only: [:show, :edit, :update, :destroy]

  # GET /message_statuses
  # GET /message_statuses.json
  def index
    @message_statuses = MessageStatus.all
  end

  # GET /message_statuses/1
  # GET /message_statuses/1.json
  def show
  end

  # GET /message_statuses/new
  def new
    @message_status = MessageStatus.new
  end

  # GET /message_statuses/1/edit
  def edit
  end

  # POST /message_statuses
  # POST /message_statuses.json
  def create
    @message_status = MessageStatus.new(message_status_params)

    respond_to do |format|
      if @message_status.save
        format.html { redirect_to @message_status, notice: 'Message status was successfully created.' }
        format.json { render :show, status: :created, location: @message_status }
      else
        format.html { render :new }
        format.json { render json: @message_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /message_statuses/1
  # PATCH/PUT /message_statuses/1.json
  def update
    respond_to do |format|
      if @message_status.update(message_status_params)
        format.html { redirect_to @message_status, notice: 'Message status was successfully updated.' }
        format.json { render :show, status: :ok, location: @message_status }
      else
        format.html { render :edit }
        format.json { render json: @message_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /message_statuses/1
  # DELETE /message_statuses/1.json
  def destroy
    @message_status.destroy
    respond_to do |format|
      format.html { redirect_to message_statuses_url, notice: 'Message status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message_status
      @message_status = MessageStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_status_params
      params.require(:message_status).permit(:name, :description, :sort_order)
    end
end
