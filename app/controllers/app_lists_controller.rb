class AppListsController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_list, only: [:show, :edit, :update, :destroy]

  # GET /app_lists
  # GET /app_lists.json
  def index
    @app_lists = AppList.all
  end

  # GET /app_lists/1
  # GET /app_lists/1.json
  def show
  end

  # GET /app_lists/new
  def new
    @app_list = AppList.new
  end

  # GET /app_lists/1/edit
  def edit
  end

  # POST /app_lists
  # POST /app_lists.json
  def create
    @app_list = AppList.new(app_list_params)

    respond_to do |format|
      if @app_list.save
        format.html { redirect_to @app_list, notice: 'App list was successfully created.' }
        format.json { render :show, status: :created, location: @app_list }
      else
        format.html { render :new }
        format.json { render json: @app_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_lists/1
  # PATCH/PUT /app_lists/1.json
  def update
    respond_to do |format|
      if @app_list.update(app_list_params)
        format.html { redirect_to @app_list, notice: 'App list was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_list }
      else
        format.html { render :edit }
        format.json { render json: @app_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_lists/1
  # DELETE /app_lists/1.json
  def destroy
    @app_list.destroy
    respond_to do |format|
      format.html { redirect_to app_lists_url, notice: 'App list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_list
      @app_list = AppList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_list_params
      params.require(:app_list).permit(:name, :priority_no, :primary_goal_of_app, :description, :version, :location)
    end
end
