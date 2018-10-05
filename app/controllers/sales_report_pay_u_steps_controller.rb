class SalesReportPayUStepsController < ApplicationController
  before_action :set_sales_report_pay_u_step, only: [:show, :edit, :update, :destroy]

  # GET /sales_report_pay_u_steps
  # GET /sales_report_pay_u_steps.json
  def index
    @sales_report_pay_u_steps = SalesReportPayUStep.all
  end

  # GET /sales_report_pay_u_steps/1
  # GET /sales_report_pay_u_steps/1.json
  def show
  end

  # GET /sales_report_pay_u_steps/new
  def new
    @sales_report_pay_u_step = SalesReportPayUStep.new
  end

  # GET /sales_report_pay_u_steps/1/edit
  def edit
  end

  # POST /sales_report_pay_u_steps
  # POST /sales_report_pay_u_steps.json
  def create
    #@sales_report_pay_u_step = SalesReportPayUStep.new(sales_report_pay_u_step_params)

    respond_to do |format|
      if @sales_report_pay_u_step.save
        format.html { redirect_to @sales_report_pay_u_step, notice: 'Sales report pay u step was successfully created.' }
        format.json { render :show, status: :created, location: @sales_report_pay_u_step }
      else
        format.html { render :new }
        format.json { render json: @sales_report_pay_u_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_report_pay_u_steps/1
  # PATCH/PUT /sales_report_pay_u_steps/1.json
  def update
    respond_to do |format|
      if @sales_report_pay_u_step.update(sales_report_pay_u_step_params)
        format.html { redirect_to @sales_report_pay_u_step, notice: 'Sales report pay u step was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_report_pay_u_step }
      else
        format.html { render :edit }
        format.json { render json: @sales_report_pay_u_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_report_pay_u_steps/1
  # DELETE /sales_report_pay_u_steps/1.json
  def destroy
   # @sales_report_pay_u_step.destroy
    respond_to do |format|
      format.html { redirect_to sales_report_pay_u_steps_url, notice: 'Sales report pay u step was not destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_report_pay_u_step
      @sales_report_pay_u_step = SalesReportPayUStep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_report_pay_u_step_params
      params.require(:sales_report_pay_u_step).permit(:name, :min_value, :max_value, :active)
    end
end
