class DispatchCallStatusesController < ApplicationController
  before_action :set_dispatch_call_status, only: [:show, :edit, :update, :destroy]

  # GET /dispatch_call_statuses
  # GET /dispatch_call_statuses.json
  def index
    @dispatch_call_statuses = DispatchCallStatus.all
  end

  # GET /dispatch_call_statuses/1
  # GET /dispatch_call_statuses/1.json
  def show
  end

  # GET /dispatch_call_statuses/new
  def new
    @dispatch_call_status = DispatchCallStatus.new
  end

  # GET /dispatch_call_statuses/1/edit
  def edit
  end

  # POST /dispatch_call_statuses
  # POST /dispatch_call_statuses.json
  def create
    @dispatch_call_status = DispatchCallStatus.new(dispatch_call_status_params)

    respond_to do |format|
      if @dispatch_call_status.save
        format.html { redirect_to @dispatch_call_status, notice: 'Dispatch call status was successfully created.' }
        format.json { render :show, status: :created, location: @dispatch_call_status }
      else
        format.html { render :new }
        format.json { render json: @dispatch_call_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dispatch_call_statuses/1
  # PATCH/PUT /dispatch_call_statuses/1.json
  def update
    respond_to do |format|
      if @dispatch_call_status.update(dispatch_call_status_params)
        format.html { redirect_to @dispatch_call_status, notice: 'Dispatch call status was successfully updated.' }
        format.json { render :show, status: :ok, location: @dispatch_call_status }
      else
        format.html { render :edit }
        format.json { render json: @dispatch_call_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dispatch_call_statuses/1
  # DELETE /dispatch_call_statuses/1.json
  def destroy
    @dispatch_call_status.destroy
    respond_to do |format|
      format.html { redirect_to dispatch_call_statuses_url, notice: 'Dispatch call status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dispatch_call_status
      @dispatch_call_status = DispatchCallStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dispatch_call_status_params
      params.require(:dispatch_call_status).permit(:name, :description, :sort_order)
    end
end
