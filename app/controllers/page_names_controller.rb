class PageNamesController < ApplicationController
  before_action :set_page_name, only: [:show, :edit, :update, :destroy]

  # GET /page_names
  # GET /page_names.json
  def index
    @page_names = PageName.all
  end

  # GET /page_names/1
  # GET /page_names/1.json
  def show
  end

  # GET /page_names/new
  def new
    @page_name = PageName.new
  end

  # GET /page_names/1/edit
  def edit
  end

  # POST /page_names
  # POST /page_names.json
  def create
    @page_name = PageName.new(page_name_params)

    respond_to do |format|
      if @page_name.save
        format.html { redirect_to @page_name, notice: 'Page name was successfully created.' }
        format.json { render :show, status: :created, location: @page_name }
      else
        format.html { render :new }
        format.json { render json: @page_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_names/1
  # PATCH/PUT /page_names/1.json
  def update
    respond_to do |format|
      if @page_name.update(page_name_params)
        format.html { redirect_to @page_name, notice: 'Page name was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_name }
      else
        format.html { render :edit }
        format.json { render json: @page_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_names/1
  # DELETE /page_names/1.json
  def destroy
    @page_name.destroy
    respond_to do |format|
      format.html { redirect_to page_names_url, notice: 'Page name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_name
      @page_name = PageName.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_name_params
      params.require(:page_name).permit(:name, :sort_order, :description)
    end
end
