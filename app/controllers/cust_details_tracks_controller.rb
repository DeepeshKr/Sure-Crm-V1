class CustDetailsTracksController < ApplicationController
  before_action :set_cust_details_track, only: [:show, :edit, :update, :destroy]

  # GET /cust_details_tracks
  # GET /cust_details_tracks.json
  def index
    @show_missed = false
    #.order(order_date: :DESC)
    @cust_details_tracks = CustDetailsTrack.limit(10).order(:order_date).paginate(:page => params[:page])
    
    if params[:from_date].present?
      @or_for_date = params[:from_date]
      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      @to_date = @from_date
      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end
    end
    if params.has_key?(:show_missed)
      @show_missed = params[:show_missed]
    end
   
    if (@from_date == nil || @to_date == nil)
      flash[:success] = "No date range selected to show detailed results"
      return    
    end
    if params[:ordernum].present?
      @ordernum = params[:ordernum]
    end
    
    @ex_from_date = @from_date.beginning_of_day #- 330.minutes
    @ex_to_date = @to_date.end_of_day #- 330.minutes
    #.order(order_date: :DESC)
    if @show_missed == "true"
      @cust_details_tracks = CustDetailsTrack.where('order_date >= ? AND order_date <= ?', @ex_from_date, @ex_to_date).where("custdetails is null").order(:order_date).paginate(:page => params[:page])
       flash[:success] = "Showing results between #{@from_date} to #{@to_date} with missed orders"
    else
      @cust_details_tracks = CustDetailsTrack.where('order_date >= ? AND order_date <= ?', @ex_from_date, @ex_to_date).order(:order_date).paginate(:page => params[:page])
      flash[:success] = "Showing results between #{@from_date} to #{@to_date} with all orders"
    end
    
    
    
    if @ordernum.present?
      @cust_details_tracks = @cust_details_tracks.where("ext_ref_id = ? or order_master_id = ? or order_ref_id = ?", @ordernum, @ordernum, @ordernum)
    else
       @orders_in_pool = OrderInPool.between_date @from_date, @to_date, @show_missed
    end

    @custdetails_order = @cust_details_tracks.where("custdetails is not null").count(:custdetails)
    @sure_crm_orders = @cust_details_tracks.count(:order_ref_id)
    @missed_order_nos = @sure_crm_orders - @custdetails_order
  #  @total_order_value = @cust_details_tracks.sum(:order_master.total_value)
    @missed_order_value = @cust_details_tracks.where("custdetails is null").joins(:order_master).sum(:total)
    
    respond_to do |format|
      format.html
      format.csv { send_data @cust_details_tracks.to_csv, filename: "orders-between#{@from_date}-and-#{@to_Date}-on-#{Date.today}.csv" }
    end
    
  end

  # GET /cust_details_tracks/1
  # GET /cust_details_tracks/1.json
  def show
    
    @cust_details_track_logs = CustDetailsTrackLog.where(cust_details_track_id: @cust_details_track.id)
  end

  # GET /cust_details_tracks/new
  def new
    @cust_details_track = CustDetailsTrack.new
  end

  # GET /cust_details_tracks/1/edit
  def edit
  end

  # POST /cust_details_tracks
  # POST /cust_details_tracks.json
  def create
    @cust_details_track = CustDetailsTrack.new(cust_details_track_params)

    respond_to do |format|
      if @cust_details_track.save
        format.html { redirect_to @cust_details_track, notice: 'Cust details track was successfully created.' }
        format.json { render :show, status: :created, location: @cust_details_track }
      else
        format.html { render :new }
        format.json { render json: @cust_details_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cust_details_tracks/1
  # PATCH/PUT /cust_details_tracks/1.json
  def update
    respond_to do |format|
      if @cust_details_track.update(cust_details_track_params)
        format.html { redirect_to @cust_details_track, notice: 'Cust details track was successfully updated.' }
        format.json { render :show, status: :ok, location: @cust_details_track }
      else
        format.html { render :edit }
        format.json { render json: @cust_details_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cust_details_tracks/1
  # DELETE /cust_details_tracks/1.json
  def destroy
    @cust_details_track.destroy
    respond_to do |format|
      format.html { redirect_to cust_details_tracks_url, notice: 'Cust details track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cust_details_track
      @cust_details_track = CustDetailsTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cust_details_track_params
      params.require(:cust_details_track).permit(:order_ref_id, :order_date, :ext_ref_id, :custdetails, :vpp, :dealtran, :last_call_back_on, :no_of_attempts, :mobile, :alt_mobile, :products, :current_status)
    end
end

# msel = "select username,count(*) from custdetails where orderdate >= '" & mdate & "' and orderdate <= '" & mtodate & "') group by username"
#
# 0.82304526