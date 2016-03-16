class DailyTaskLogsController < ApplicationController
  before_action :set_daily_task_log, only: [:show, :edit, :update, :destroy]

  # GET /daily_task_logs
  # GET /daily_task_logs.json
  def index
    @daily_task_logs = DailyTaskLog.all
  end

  # GET /daily_task_logs/1
  # GET /daily_task_logs/1.json
  def show
  end

  # GET /daily_task_logs/new
  def new
    @daily_task_log = DailyTaskLog.new
  end

  # GET /daily_task_logs/1/edit
  def edit
  end

  # POST /daily_task_logs
  # POST /daily_task_logs.json
  def create
    @daily_task_log = DailyTaskLog.new(daily_task_log_params)

    respond_to do |format|
      if @daily_task_log.save
        format.html { redirect_to @daily_task_log, notice: 'Daily task log was successfully created.' }
        format.json { render :show, status: :created, location: @daily_task_log }
      else
        format.html { render :new }
        format.json { render json: @daily_task_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_task_logs/1
  # PATCH/PUT /daily_task_logs/1.json
  def update
    respond_to do |format|
      if @daily_task_log.update(daily_task_log_params)
        format.html { redirect_to @daily_task_log, notice: 'Daily task log was successfully updated.' }
        format.json { render :show, status: :ok, location: @daily_task_log }
      else
        format.html { render :edit }
        format.json { render json: @daily_task_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_task_logs/1
  # DELETE /daily_task_logs/1.json
  def destroy
    @daily_task_log.destroy
    respond_to do |format|
      format.html { redirect_to daily_task_logs_url, notice: 'Daily task log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_task_log
      @daily_task_log = DailyTaskLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_task_log_params
      params.require(:daily_task_log).permit(:daily_task_id, :name, :syntax_error, :status, :checked_on, :checked_by)
    end
end
