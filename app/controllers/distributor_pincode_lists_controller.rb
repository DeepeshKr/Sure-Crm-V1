class DistributorPincodeListsController < ApplicationController
  before_action :set_distributor_pincode_list, only: [:show, :edit, :update, :destroy]

  # GET /distributor_pincode_lists
  # GET /distributor_pincode_lists.json
  def index
    if params.has_key? :corporate_id
      @distributor_pincode_lists = DistributorPincodeList.where(corporate_id: params[:corporate_id]).sort("pincode, name").paginate(:page => params[:page])
    else
      @distributor_pincode_lists = DistributorPincodeList.all.order("pincode, name").paginate(:page => params[:page]) 
      #.sort("pincode, name")
    end
    
  end

  # GET /distributor_pincode_lists/1
  # GET /distributor_pincode_lists/1.json
  def show
  end

  # GET /distributor_pincode_lists/new
  def new
    @distributor_pincode_list = DistributorPincodeList.new
  end

  # GET /distributor_pincode_lists/1/edit
  def edit
  end

  # POST /distributor_pincode_lists
  # POST /distributor_pincode_lists.json
  def create
    @distributor_pincode_list = DistributorPincodeList.new(distributor_pincode_list_params)

    respond_to do |format|
      if @distributor_pincode_list.save
        format.html { redirect_to @distributor_pincode_list, notice: 'Distributor pincode list was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_pincode_list }
      else
        format.html { render :new }
        format.json { render json: @distributor_pincode_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_pincode_lists/1
  # PATCH/PUT /distributor_pincode_lists/1.json
  def update
    respond_to do |format|
      if @distributor_pincode_list.update(distributor_pincode_list_params)
        format.html { redirect_to @distributor_pincode_list, notice: 'Distributor pincode list was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_pincode_list }
      else
        format.html { render :edit }
        format.json { render json: @distributor_pincode_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_pincode_lists/1
  # DELETE /distributor_pincode_lists/1.json
  def destroy
    @distributor_pincode_list.destroy
    respond_to do |format|
      format.html { redirect_to distributor_pincode_lists_url, notice: 'Distributor pincode list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_pincode_list
      @distributor_pincode_list = DistributorPincodeList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_pincode_list_params
      params.require(:distributor_pincode_list).permit(:name, :corporate_id,
       :sort_order, :pincode)
    end
end
