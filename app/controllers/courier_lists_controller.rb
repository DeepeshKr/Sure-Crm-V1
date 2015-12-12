class CourierListsController < ApplicationController
  before_action :set_courier_list, only: [:show, :edit, :update, :destroy]

  # GET /courier_lists
  # GET /courier_lists.json
  def index
    @courier_lists = CourierList.all
  end

  # GET /courier_lists/1
  # GET /courier_lists/1.json
  def show
  end

  # GET /courier_lists/new
  def new
    @courier_list = CourierList.new
  end

  # GET /courier_lists/1/edit
  def edit
  end

  # POST /courier_lists
  # POST /courier_lists.json
  def create
    @courier_list = CourierList.new(courier_list_params)

    respond_to do |format|
      if @courier_list.save
        format.html { redirect_to @courier_list, notice: 'Courier list was successfully created.' }
        format.json { render :show, status: :created, location: @courier_list }
      else
        format.html { render :new }
        format.json { render json: @courier_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courier_lists/1
  # PATCH/PUT /courier_lists/1.json
  def update
    respond_to do |format|
      if @courier_list.update(courier_list_params)
        format.html { redirect_to @courier_list, notice: 'Courier list was successfully updated.' }
        format.json { render :show, status: :ok, location: @courier_list }
      else
        format.html { render :edit }
        format.json { render json: @courier_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courier_lists/1
  # DELETE /courier_lists/1.json
  def destroy
    @courier_list.destroy
    respond_to do |format|
      format.html { redirect_to courier_lists_url, notice: 'Courier list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_courier_list
      @courier_list = CourierList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def courier_list_params
      params.require(:courier_list).permit(:name, :description, :contact_details, :tracking_url, :helpline, :sort_order, :ref_code, :active)
    end
end
