class PayumoneyStatusesController < ApplicationController
  before_action :set_payumoney_status, only: [:show, :edit, :update, :destroy]

  # GET /payumoney_statuses
  # GET /payumoney_statuses.json
  def index
    @payumoney_statuses = PayumoneyStatus.all.order(:priority_no)
  end

  # GET /payumoney_statuses/1
  # GET /payumoney_statuses/1.json
  def show
  end

  # GET /payumoney_statuses/new
  def new
    @payumoney_status = PayumoneyStatus.new
  end

  # GET /payumoney_statuses/1/edit
  def edit
  end

  # POST /payumoney_statuses
  # POST /payumoney_statuses.json
  def create
    @payumoney_status = PayumoneyStatus.new(payumoney_status_params)

    respond_to do |format|
      if @payumoney_status.save
        format.html { redirect_to @payumoney_status, notice: 'Payumoney status was successfully created.' }
        format.json { render :show, status: :created, location: @payumoney_status }
      else
        format.html { render :new }
        format.json { render json: @payumoney_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payumoney_statuses/1
  # PATCH/PUT /payumoney_statuses/1.json
  def update
    respond_to do |format|
      if @payumoney_status.update(payumoney_status_params)
        format.html { redirect_to @payumoney_status, notice: 'Payumoney status was successfully updated.' }
        format.json { render :show, status: :ok, location: @payumoney_status }
      else
        format.html { render :edit }
        format.json { render json: @payumoney_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payumoney_statuses/1
  # DELETE /payumoney_statuses/1.json
  def destroy
    @payumoney_status.destroy
    respond_to do |format|
      format.html { redirect_to payumoney_statuses_url, notice: 'Payumoney status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payumoney_status
      @payumoney_status = PayumoneyStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payumoney_status_params
      params.require(:payumoney_status).permit(:name, :priority_no, :external_description, :valid_payment, :description)
    end
end
