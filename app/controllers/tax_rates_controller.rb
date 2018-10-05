class TaxRatesController < ApplicationController
  before_action { protect_controllers(8) } 
  before_action :set_tax_rate, only: [:show, :edit, :update, :destroy]

  # GET /tax_rates
  # GET /tax_rates.json
  def index
    @return_url = request.host
    @tax_rates = TaxRate.all
    set_default_values
  end

  # GET /tax_rates/1
  # GET /tax_rates/1.json
  def show
  end

  # GET /tax_rates/new
  def new
    @states = State.all.order("name")
    @tax_rate = TaxRate.new
  end

  # GET /tax_rates/1/edit
  def edit
    @states = State.all.order("name")
  end

  # POST /tax_rates
  # POST /tax_rates.json
  def create
    @states = State.all.order("name")
    @tax_rate = TaxRate.new(tax_rate_params)

    respond_to do |format|
      if @tax_rate.save
        format.html { redirect_to @tax_rate, notice: 'Tax rate was successfully created.' }
        format.json { render :show, status: :created, location: @tax_rate }
      else
        format.html { render :new }
        format.json { render json: @tax_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tax_rates/1
  # PATCH/PUT /tax_rates/1.json
  def update
    @states = State.all.order("name")
    respond_to do |format|
      if @tax_rate.update(tax_rate_params)
        format.html { redirect_to @tax_rate, notice: 'Tax rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @tax_rate }
      else
        format.html { render :edit }
        format.json { render json: @tax_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tax_rates/1
  # DELETE /tax_rates/1.json
  def destroy
    @tax_rate.destroy
    respond_to do |format|
      format.html { redirect_to tax_rates_url, notice: 'Tax rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax_rate

      @tax_rate = TaxRate.find(params[:id])
    end
    def set_default_values
      @reverse_vat_rate = TaxRate.find(10001)
      @reverse_ship_rate = TaxRate.find(10020)
      @reverse_transfer_rate = TaxRate.find(10040)
      @reverse_dealer_rate = TaxRate.find(10041)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def tax_rate_params
      params.require(:tax_rate).permit(:name, :tax_rate, :reverse_rate, :description, :is_external)
    end
end
