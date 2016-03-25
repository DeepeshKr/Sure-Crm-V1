class DistributorUploadOrdersController < ApplicationController
    before_action { protect_controllers(6) }
  before_action :set_distributor_upload_order, only: [:show, :edit, :update, :destroy]

  # GET /distributor_upload_orders
  # GET /distributor_upload_orders.json
  def index
    @distributor_upload_orders = DistributorUploadOrder.all
  end

  # GET /distributor_upload_orders/1
  # GET /distributor_upload_orders/1.json
  def show
  end

  # GET /distributor_upload_orders/new
  def new
    @distributor_upload_order = DistributorUploadOrder.new
  end

  # GET /distributor_upload_orders/1/edit
  def edit
  end

  def switch_on
    switch
    @distributor_upload_order = DistributorUploadOrder.first
    @distributor_upload_order.update(online_order_id: 1, online_description: @message, online_last_ran_on: t)
    flash[:notice] = "Switched on #{@message}"
    redirect_to corporates_path
  end

  def switch_off
    switch
    @distributor_upload_order = DistributorUploadOrder.first
    @distributor_upload_order.update(online_order_id: 0, online_description: @message, online_last_ran_on: t)

    flash[:notice] = "Switched off #{@message}"
    redirect_to corporates_path
  end

  # POST /distributor_upload_orders
  # POST /distributor_upload_orders.json
  def create
    @distributor_upload_order = DistributorUploadOrder.new(distributor_upload_order_params)

    respond_to do |format|
      if @distributor_upload_order.save
        format.html { redirect_to @distributor_upload_order, notice: 'Distributor upload order was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_upload_order }
      else
        format.html { render :new }
        format.json { render json: @distributor_upload_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_upload_orders/1
  # PATCH/PUT /distributor_upload_orders/1.json
  def update
    respond_to do |format|
      if @distributor_upload_order.update(distributor_upload_order_params)
        format.html { redirect_to @distributor_upload_order, notice: 'Distributor upload order was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_upload_order }
      else
        format.html { render :edit }
        format.json { render json: @distributor_upload_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_upload_orders/1
  # DELETE /distributor_upload_orders/1.json
  def destroy
    @distributor_upload_order.destroy
    respond_to do |format|
      format.html { redirect_to distributor_upload_orders_url, notice: 'Distributor upload order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_upload_order
      @distributor_upload_order = DistributorUploadOrder.find(params[:id])
    end

    def switch
      t = Time.zone.now + 330.minutes
      @empcode = current_user.employee_code
      #@empid = current_user.id
      @employee = Employee.where(employeecode: @empcode).first
      @message = "Update by #{@employee.employee_name} at time #{t.strftime("%d-%b-%Y %H:%M:%SS")}"
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_upload_order_params
      params.require(:distributor_upload_order).permit(:order_id, :ext_order_id, :last_ran_on, :description, :online_order_id, :online_last_ran_on, :online_description)
    end
end
