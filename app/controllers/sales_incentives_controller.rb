class SalesIncentivesController < ApplicationController
  before_action :set_sales_incentive, only: [:show, :edit, :update, :destroy]

  # GET /sales_incentives
  # GET /sales_incentives.json
  def index
    @sales_incentives = SalesIncentive.all
  end

  # GET /sales_incentives/1
  # GET /sales_incentives/1.json
  def show
  end

  # GET /sales_incentives/new
  def new
    @sales_incentive = SalesIncentive.new
  end

  # GET /sales_incentives/1/edit
  def edit
  end

  # POST /sales_incentives
  # POST /sales_incentives.json
  def create
    @sales_incentive = SalesIncentive.new(sales_incentive_params)

    respond_to do |format|
      if @sales_incentive.save
        format.html { redirect_to @sales_incentive, notice: 'Sales incentive was successfully created.' }
        format.json { render :show, status: :created, location: @sales_incentive }
      else
        format.html { render :new }
        format.json { render json: @sales_incentive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_incentives/1
  # PATCH/PUT /sales_incentives/1.json
  def update
    respond_to do |format|
      if @sales_incentive.update(sales_incentive_params)
        format.html { redirect_to @sales_incentive, notice: 'Sales incentive was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_incentive }
      else
        format.html { render :edit }
        format.json { render json: @sales_incentive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_incentives/1
  # DELETE /sales_incentives/1.json
  def destroy
    @sales_incentive.destroy
    respond_to do |format|
      format.html { redirect_to sales_incentives_url, notice: 'Sales incentive was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_incentive
      @sales_incentive = SalesIncentive.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_incentive_params
      params.require(:sales_incentive).permit(:name, :min_value, :max_value, :commission, :no_of, :description)
    end
end
