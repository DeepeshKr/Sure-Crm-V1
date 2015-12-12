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
  # $( "#distributor_pincode_list_pincode" ).val( ui.item.pincode);
  # $( "#distributor_pincode_list_city" ).val( ui.item.regionname);
  #  $( "#distributor_pincode_list_locality" ).val( ui.item.officename);
  # $( "#distributor_pincode_list_state" ).val( ui.item.statename );
  def quick_add_pincode
    corporate_id = params[:corporate_id]
    pincode = params[:pincode]
    @distributor_pincode_list = DistributorPincodeList.new(corporate_id: corporate_id, pincode: pincode)
    pin_codes = IndiaPincodeList.where(pincode: pincode)
    if !pin_codes.present?
      flash[:error] = "Pincode #{pincode} was incorrect. "
      return redirect_to corporate_path @distributor_pincode_list.corporate_id

    end
    locality = pin_codes.first.officename
    city = pin_codes.first.officename
    state = pin_codes.first.regionname
    #:corporate_id, :sort_order, :city, :state, :locality, :pincode
    @distributor_pincode_list.sort_order = 1
    @distributor_pincode_list.city = city
    @distributor_pincode_list.state = state
    @distributor_pincode_list.locality = locality
    if  @distributor_pincode_list.save
    flash[:success] = 'Pincode was added successfully successfully!'
    else
     flash[:error] = @distributor_pincode_list.errors.full_messages.to_sentence
     flash[:notice] = @distributor_pincode_list.errors.full_messages.to_sentence
    end

    redirect_to corporate_path @distributor_pincode_list.corporate_id
  end
  # POST /distributor_pincode_lists
  # POST /distributor_pincode_lists.json
  def create
    @distributor_pincode_list = DistributorPincodeList.new(distributor_pincode_list_params)

    respond_to do |format|
      if @distributor_pincode_list.save
        format.html { redirect_to corporate_path @distributor_pincode_list.corporate_id, notice: 'Distributor pincode list was successfully created.' }
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
        format.html { redirect_to corporate_path @distributor_pincode_list.corporate_id, notice: 'Distributor pincode list was successfully updated.' }
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
      format.html { redirect_to corporate_path @distributor_pincode_list.corporate_id, notice: 'Distributor pincode list was successfully destroyed.' }
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
      params.require(:distributor_pincode_list).permit(:corporate_id,
       :sort_order, :city, :state, :locality, :pincode)
    end
end
