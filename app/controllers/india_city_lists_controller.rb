class IndiaCityListsController < ApplicationController
  before_action :set_india_city_list, only: [:show, :edit, :update, :destroy]

  # GET /india_city_lists
  # GET /india_city_lists.json
  def index
    # product_hash = row.to_hash # exclude the price field
    oldcitylist = CITYLIST.all
    oldcitylist.each do |row|
      product = IndiaCityList.where(name: row["city"])

       if product.present?
         product.first.update_attributes(state: row['state'])
       else
        IndiaCityList.create(name: row['city'], state: row['state'])
      end # end if !product.nil?
     end # end CSV.foreach
    @india_city_lists = IndiaCityList.all
  end

  # GET /india_city_lists/1
  # GET /india_city_lists/1.json
  def show
  end

  # GET /india_city_lists/new
  def new
    @india_city_list = IndiaCityList.new
  end

  # GET /india_city_lists/1/edit
  def edit
  end

  # POST /india_city_lists
  # POST /india_city_lists.json
  def create
    @india_city_list = IndiaCityList.new(india_city_list_params)

    respond_to do |format|
      if @india_city_list.save
        format.html { redirect_to @india_city_list, notice: 'India city list was successfully created.' }
        format.json { render :show, status: :created, location: @india_city_list }
      else
        format.html { render :new }
        format.json { render json: @india_city_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /india_city_lists/1
  # PATCH/PUT /india_city_lists/1.json
  def update
    respond_to do |format|
      if @india_city_list.update(india_city_list_params)
        format.html { redirect_to @india_city_list, notice: 'India city list was successfully updated.' }
        format.json { render :show, status: :ok, location: @india_city_list }
      else
        format.html { render :edit }
        format.json { render json: @india_city_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /india_city_lists/1
  # DELETE /india_city_lists/1.json
  def destroy
    @india_city_list.destroy
    respond_to do |format|
      format.html { redirect_to india_city_lists_url, notice: 'India city list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_india_city_list
      @india_city_list = IndiaCityList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def india_city_list_params
      params.require(:india_city_list).permit(:name, :state)
    end
end
