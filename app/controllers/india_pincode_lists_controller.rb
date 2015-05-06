class IndiaPincodeListsController < ApplicationController
  before_action :set_india_pincode_list, only: [:show, :edit, :update, :destroy]

  autocomplete :india_pincode_list, :pincode
  autocomplete :india_pincode_list, :taluk, :full => true
  autocomplete :india_pincode_list, :districtname, :full => true
  autocomplete :india_pincode_list, :regionname, :full => true
  # GET /india_pincode_lists
  # GET /india_pincode_lists.json
  def index
    if params[:pincode].present?
      @searchvalue = params[:pincode]
      @india_pincode_lists = IndiaPincodeList.where(pincode:  @searchvalue)
    end
    if params[:location].present?
      @searchvalue = params[:location]
      @india_pincode_lists = IndiaPincodeList.where("taluk like ? OR districtname like ? or regionname like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
    end
      @india_pincode_lists = IndiaPincodeList.all.limit(1000)
  end

  def import
    #begin
      IndiaPincodeList.import(params[:file])
      redirect_to root_url, notice: "Products imported."
    #rescue
     # redirect_to root_url, notice: "Invalid CSV file format."
    #end
  end

  # GET /india_pincode_lists/1
  # GET /india_pincode_lists/1.json
  def show
  end

  # GET /india_pincode_lists/new
  def new
    @india_pincode_list = IndiaPincodeList.new
  end

  # GET /india_pincode_lists/1/edit
  def edit
  end

  # POST /india_pincode_lists
  # POST /india_pincode_lists.json
  def create
    @india_pincode_list = IndiaPincodeList.new(india_pincode_list_params)

    respond_to do |format|
      if @india_pincode_list.save
        format.html { redirect_to @india_pincode_list, notice: 'India pincode list was successfully created.' }
        format.json { render :show, status: :created, location: @india_pincode_list }
      else
        format.html { render :new }
        format.json { render json: @india_pincode_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /india_pincode_lists/1
  # PATCH/PUT /india_pincode_lists/1.json
  def update
    respond_to do |format|
      if @india_pincode_list.update(india_pincode_list_params)
        format.html { redirect_to @india_pincode_list, notice: 'India pincode list was successfully updated.' }
        format.json { render :show, status: :ok, location: @india_pincode_list }
      else
        format.html { render :edit }
        format.json { render json: @india_pincode_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /india_pincode_lists/1
  # DELETE /india_pincode_lists/1.json
  def destroy
    @india_pincode_list.destroy
    respond_to do |format|
      format.html { redirect_to india_pincode_lists_url, notice: 'India pincode list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_india_pincode_list
      @india_pincode_list = IndiaPincodeList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def india_pincode_list_params
      params.require(:india_pincode_list).permit(:officename, :pincode, :deliverystatus, :divisionname, :regionname, :circlename, :taluk, :districtname, :statename)
    end
end