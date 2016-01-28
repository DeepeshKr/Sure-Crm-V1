class FatToFitEmailStatusesController < ApplicationController
  before_action { protect_controllers(10) }
  before_action :set_fat_to_fit_email_status, only: [:show, :edit, :update, :destroy]

  # GET /fat_to_fit_email_statuses
  # GET /fat_to_fit_email_statuses.json
  def index

    @fat_to_fit_email_no_email_id = FatToFitEmailStatus.where("emailid IS NULL").paginate(:page => params[:page])
    @fat_to_fit_emails_sent = FatToFitEmailStatus.where(send_status: 3, registration_status_id: 10001).paginate(:page => params[:page])
    @fat_to_fit_emails_queue = FatToFitEmailStatus.where(send_status: 0, registration_status_id: 10000).paginate(:page => params[:page])
  end

  # GET /fat_to_fit_email_statuses/1
  # GET /fat_to_fit_email_statuses/1.json
  def show
  end

  # GET /fat_to_fit_email_statuses/new
  def new
    @fat_to_fit_email_status = FatToFitEmailStatus.new
  end

  # GET /fat_to_fit_email_statuses/1/edit
  def edit
  end

  # POST /fat_to_fit_email_statuses
  # POST /fat_to_fit_email_statuses.json
  def create
    @fat_to_fit_email_status = FatToFitEmailStatus.new(fat_to_fit_email_status_params)

    respond_to do |format|
      if @fat_to_fit_email_status.save
        format.html { redirect_to @fat_to_fit_email_status, notice: 'Fat to fit email status was successfully created.' }
        format.json { render :show, status: :created, location: @fat_to_fit_email_status }
      else
        format.html { render :new }
        format.json { render json: @fat_to_fit_email_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fat_to_fit_email_statuses/1
  # PATCH/PUT /fat_to_fit_email_statuses/1.json
  def update
    respond_to do |format|
      if @fat_to_fit_email_status.update(fat_to_fit_email_status_params)
        format.html { redirect_to @fat_to_fit_email_status, notice: 'Fat to fit email status was successfully updated.' }
        format.json { render :show, status: :ok, location: @fat_to_fit_email_status }
      else
        format.html { render :edit }
        format.json { render json: @fat_to_fit_email_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fat_to_fit_email_statuses/1
  # DELETE /fat_to_fit_email_statuses/1.json
  def destroy
    @fat_to_fit_email_status.destroy
    respond_to do |format|
      format.html { redirect_to fat_to_fit_email_statuses_url, notice: 'Fat to fit email status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fat_to_fit_email_status
      @fat_to_fit_email_status = FatToFitEmailStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fat_to_fit_email_status_params
      params.require(:fat_to_fit_email_status).permit(:emailid, :full_name, :products, :order_no, :order_id, :send_status, :last_ran_date)
    end
end
