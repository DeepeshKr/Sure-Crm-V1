class VppDealTransController < ApplicationController
  before_action :set_vpp_deal_tran, only: [:show, :edit, :update, :destroy]

  # GET /vpp_deal_trans
  # GET /vpp_deal_trans.json
  def index
    @vpp_deal_trans = VppDealTran.all
  end

  # GET /vpp_deal_trans/1
  # GET /vpp_deal_trans/1.json
  def show
  end

  # GET /vpp_deal_trans/new
  def new
    @vpp_deal_tran = VppDealTran.new
  end

  # GET /vpp_deal_trans/1/edit
  def edit
  end

  # POST /vpp_deal_trans
  # POST /vpp_deal_trans.json
  def create
    @vpp_deal_tran = VppDealTran.new(vpp_deal_tran_params)

    respond_to do |format|
      if @vpp_deal_tran.save
        format.html { redirect_to @vpp_deal_tran, notice: 'Vpp deal tran was successfully created.' }
        format.json { render :show, status: :created, location: @vpp_deal_tran }
      else
        format.html { render :new }
        format.json { render json: @vpp_deal_tran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vpp_deal_trans/1
  # PATCH/PUT /vpp_deal_trans/1.json
  def update
    respond_to do |format|
      if @vpp_deal_tran.update(vpp_deal_tran_params)
        format.html { redirect_to @vpp_deal_tran, notice: 'Vpp deal tran was successfully updated.' }
        format.json { render :show, status: :ok, location: @vpp_deal_tran }
      else
        format.html { render :edit }
        format.json { render json: @vpp_deal_tran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vpp_deal_trans/1
  # DELETE /vpp_deal_trans/1.json
  def destroy
    @vpp_deal_tran.destroy
    respond_to do |format|
      format.html { redirect_to vpp_deal_trans_url, notice: 'Vpp deal tran was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vpp_deal_tran
      @vpp_deal_tran = VppDealTran.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vpp_deal_tran_params
      params.require(:vpp_deal_tran).permit(:actdate,:action, :add1, :add2, :add3, 
      :barcode, :barcode2, :barcode3, :basicprice, :cfo, :channel, :city, :claimdate, 
      :codamt, :convcharges, :cou, :custref, :debitnote, :debitnotedate, :delvdate, 
      :deo, :dept, :despatch, :dist, :distcode,:distname, :dt_hour, :dt_min, 
      :email, :emi, :entrydate, :fax, :fname, :invdate, :fsize, :invoice,
      :invoiceamount, :landmark, :letter, :lessprod, :lname, :loydate, 
      :manifest, :modby, :moddt, :notice, :normal, :operator, :order_number,
      :orderdate, :orderno, :ordersource, :paidamt, :paiddate, 
      :ordertype, :pin, :postage, :probag, :prod, :qty, :remarks, :refundamt, 
      :refundcheck, :refundcheckdate, :refunddate, :returndate, :sanction, :shdate, 
      :shipped, :state, :status, :statusdate, :taxamt, :taxper, :tel1, :tel2,
      :tempstatus, :tempstatusdate, :temptrandate, :title, :trandate,
      :transfer, :trantype, :vpp, :weight, :invoicerefno, :description,
      :order_last_mile_id, :order_final_status_id)
    end
end
