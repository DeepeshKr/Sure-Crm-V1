class AppPrioritiesController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_priority, only: [:show, :edit, :update, :destroy]

  # GET /app_priorities
  # GET /app_priorities.json
  def index
    @app_priorities = AppPriority.all
  end

  # GET /app_priorities/1
  # GET /app_priorities/1.json
  def show
  end

  # GET /app_priorities/new
  def new
    @app_priority = AppPriority.new
  end

  # GET /app_priorities/1/edit
  def edit
  end

  # POST /app_priorities
  # POST /app_priorities.json
  def create
    @app_priority = AppPriority.new(app_priority_params)

    respond_to do |format|
      if @app_priority.save
        format.html { redirect_to @app_priority, notice: 'App priority was successfully created.' }
        format.json { render :show, status: :created, location: @app_priority }
      else
        format.html { render :new }
        format.json { render json: @app_priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_priorities/1
  # PATCH/PUT /app_priorities/1.json
  def update
    respond_to do |format|
      if @app_priority.update(app_priority_params)
        format.html { redirect_to @app_priority, notice: 'App priority was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_priority }
      else
        format.html { render :edit }
        format.json { render json: @app_priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_priorities/1
  # DELETE /app_priorities/1.json
  def destroy
    @app_priority.destroy
    respond_to do |format|
      format.html { redirect_to app_priorities_url, notice: 'App priority was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_priority
      @app_priority = AppPriority.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_priority_params
      params.require(:app_priority).permit(:name, :priority_no, :description)
    end
end
