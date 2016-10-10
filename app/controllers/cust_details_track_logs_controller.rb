class CustDetailsTrackLogsController < ApplicationController
  before_action :set_cust_details_track_log, only: [:show, :edit, :update, :destroy]

  # GET /cust_details_track_logs
  # GET /cust_details_track_logs.json
  def index
    @cust_details_track_logs = CustDetailsTrackLog.all
  end

  # GET /cust_details_track_logs/1
  # GET /cust_details_track_logs/1.json
  def show
  end

  # GET /cust_details_track_logs/new
  def new
    @cust_details_track_log = CustDetailsTrackLog.new
  end

  # GET /cust_details_track_logs/1/edit
  def edit
  end

  # POST /cust_details_track_logs
  # POST /cust_details_track_logs.json
  def create
    @cust_details_track_log = CustDetailsTrackLog.new(cust_details_track_log_params)

    respond_to do |format|
      if @cust_details_track_log.save
        format.html { redirect_to @cust_details_track_log, notice: 'Cust details track log was successfully created.' }
        format.json { render :show, status: :created, location: @cust_details_track_log }
      else
        format.html { render :new }
        format.json { render json: @cust_details_track_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cust_details_track_logs/1
  # PATCH/PUT /cust_details_track_logs/1.json
  def update
    respond_to do |format|
      if @cust_details_track_log.update(cust_details_track_log_params)
        format.html { redirect_to @cust_details_track_log, notice: 'Cust details track log was successfully updated.' }
        format.json { render :show, status: :ok, location: @cust_details_track_log }
      else
        format.html { render :edit }
        format.json { render json: @cust_details_track_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cust_details_track_logs/1
  # DELETE /cust_details_track_logs/1.json
  def destroy
    @cust_details_track_log.destroy
    respond_to do |format|
      format.html { redirect_to cust_details_track_logs_url, notice: 'Cust details track log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cust_details_track_log
      @cust_details_track_log = CustDetailsTrackLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cust_details_track_log_params
      params.require(:cust_details_track_log).permit(:cust_details_track_id, :name, :description)
    end
end
