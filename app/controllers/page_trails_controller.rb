class PageTrailsController < ApplicationController
  before_action :set_page_trail, only: [:show, :edit, :update, :destroy]

  # GET /page_trails
  # GET /page_trails.json
  def index
    dropdowns
    if params.has_key?(:order_id) 
      
      @search = "Search for Order No: " +  params[:search].upcase
      @searchvalue = params[:search].upcase   
      @page_trails = PageTrail.where(order_id: params[:order_id]).paginate(:page => params[:page], :per_page => 50)

      @found = @product_masters.count
    elsif params.has_key?(:employee_id) 
      
      @search = "Search for Order No: " +  params[:search].upcase
      @searchvalue = params[:search].upcase   
      @page_trails = PageTrail.where(employee_id: params[:employee_id]).paginate(:page => params[:page], :per_page => 50)

      @found = @product_masters.count
     else
      @page_trails = PageTrail.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 50) 
     end

    
  end

  # GET /page_trails/1
  # GET /page_trails/1.json
  def show
  end

  # GET /page_trails/new
  def new
    @page_trail = PageTrail.new
  end

  # GET /page_trails/1/edit
  def edit
  end

  # POST /page_trails
  # POST /page_trails.json
  def create
    @page_trail = PageTrail.new(page_trail_params)

    respond_to do |format|
      if @page_trail.save
        format.html { redirect_to @page_trail, notice: 'Page trail was successfully created.' }
        format.json { render :show, status: :created, location: @page_trail }
      else
        format.html { render :new }
        format.json { render json: @page_trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_trails/1
  # PATCH/PUT /page_trails/1.json
  def update
    respond_to do |format|
      if @page_trail.update(page_trail_params)
        format.html { redirect_to @page_trail, notice: 'Page trail was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_trail }
      else
        format.html { render :edit }
        format.json { render json: @page_trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_trails/1
  # DELETE /page_trails/1.json
  def destroy
    @page_trail.destroy
    respond_to do |format|
      format.html { redirect_to page_trails_url, notice: 'Page trail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def dropdowns
    @sales_staff = Employee.all.joins(:employee_role).where("employee_roles.sortorder > 7")
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_page_trail
      @page_trail = PageTrail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_trail_params
      params.require(:page_trail).permit(:name, :order_id, :page_id, :url, :employee_id, :duration_secs)
    end
end
