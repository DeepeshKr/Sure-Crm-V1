class TransferOrderLinesController < ApplicationController
  before_action :set_transfer_order_line, only: [:show, :edit, :update, :destroy]

  # GET /transfer_order_lines
  # GET /transfer_order_lines.json
  def index
    @transfer_order_lines = TransferOrderLine.all
  end

  # GET /transfer_order_lines/1
  # GET /transfer_order_lines/1.json
  def show
  end

  # GET /transfer_order_lines/new
  def new
    @transfer_order_line = TransferOrderLine.new
  end

  # GET /transfer_order_lines/1/edit
  def edit
  end

  # POST /transfer_order_lines
  # POST /transfer_order_lines.json
  def create
    @transfer_order_line = TransferOrderLine.new(transfer_order_line_params)

    respond_to do |format|
      if @transfer_order_line.save
        format.html { redirect_to @transfer_order_line, notice: 'Transfer order line was successfully created.' }
        format.json { render :show, status: :created, location: @transfer_order_line }
      else
        format.html { render :new }
        format.json { render json: @transfer_order_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfer_order_lines/1
  # PATCH/PUT /transfer_order_lines/1.json
  def update
    respond_to do |format|
      if @transfer_order_line.update(transfer_order_line_params)
        format.html { redirect_to @transfer_order_line, notice: 'Transfer order line was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer_order_line }
      else
        format.html { render :edit }
        format.json { render json: @transfer_order_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_order_lines/1
  # DELETE /transfer_order_lines/1.json
  def destroy
    @transfer_order_line.destroy
    respond_to do |format|
      format.html { redirect_to transfer_order_lines_url, notice: 'Transfer order line was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer_order_line
      @transfer_order_line = TransferOrderLine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_order_line_params
      params.require(:transfer_order_line).permit(:transfer_order_id, :prod, :description, :product_list_id, :product_variant_id, :product_master_id, :pieces, :sub_total, :shipping, :codcharges, :total, :transfer_order_status_id, :notes)
    end
end
