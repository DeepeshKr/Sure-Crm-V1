class DailyTasksController < ApplicationController
  before_action :set_daily_task, only: [:show, :edit, :update, :destroy]

  # GET /daily_tasks
  # GET /daily_tasks.json
  def index
    #@daily_tasks = DailyTask.all



     if params[:search].present?
         @search = params[:search]
        @daily_tasks_search = DailyTask.where(sort_order: @search)
       end
        @daily_tasks_instant = DailyTask.where(frequency: "Instant - within 300 secs").order(:sort_order)
        @daily_tasks_once = DailyTask.where(frequency: "Once Daily").order(:sort_order)
        @daily_tasks_demand = DailyTask.where(frequency: "On Demand").order(:sort_order)
        @daily_tasks_30 = DailyTask.where(frequency: "Every 30 min").order(:sort_order)
        @daily_tasks_trial = DailyTask.where(frequency: "On Trial").order(:sort_order)

        todaydate = Date.today #Time.zone.now + 330.minutes
        @from_date = todaydate - 30.days #30.days
        @to_date = todaydate
        @daily_task_ppo_status = []

        #upto
        (@to_date).downto(@from_date).each do |day|
         #for_date =  Date.strptime(day, "%Y-%m-%d")

        totalorders = OrderMaster.where("TRUNC(orderdate) = ?", day)
        .where('ORDER_STATUS_MASTER_ID > 10002').count

        hbnorders = OrderMaster.where("TRUNC(orderdate) = ?", day)
        .where('ORDER_STATUS_MASTER_ID > 10002').joins(:medium).where("media.media_group_id = 10000").count

         total_ppo_orders = SalesPpo.where('order_status_id > 10002')
         .where("TRUNC(start_time) = ? ", day).distinct.count('order_id')

          @daily_task_ppo_status << {:total_orders => totalorders.to_i,
            :hbn_orders => hbnorders.to_i,
          :for_date =>  day.strftime("%d-%b-%Y"),
          :total_ppo => total_ppo_orders.to_i,
          :difference => (hbnorders - total_ppo_orders).to_i}
        end

  end

  # GET /daily_tasks/1
  # GET /daily_tasks/1.json
  def show
  end

  # GET /daily_tasks/new
  def new
    last_sort_order = DailyTask.order("sort_order DESC").first.sort_order
    @daily_task = DailyTask.new(sort_order: last_sort_order + 1)
  end

  # GET /daily_tasks/1/edit
  def edit
  end

  # POST /daily_tasks
  # POST /daily_tasks.json
  def create

    @daily_task = DailyTask.new(daily_task_params)

    respond_to do |format|
      if @daily_task.save
        format.html { redirect_to @daily_task, notice: 'Daily task was successfully created.' }
        format.json { render :show, status: :created, location: @daily_task }
      else
        format.html { render :new }
        format.json { render json: @daily_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_tasks/1
  # PATCH/PUT /daily_tasks/1.json
  def update
    respond_to do |format|
      if @daily_task.update(daily_task_params)
        format.html { redirect_to @daily_task, notice: 'Daily task was successfully updated.' }
        format.json { render :show, status: :ok, location: @daily_task }
      else
        format.html { render :edit }
        format.json { render json: @daily_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_tasks/1
  # DELETE /daily_tasks/1.json
  def destroy
    @daily_task.destroy
    respond_to do |format|
      format.html { redirect_to daily_tasks_url, notice: 'Daily task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_task
      @daily_task = DailyTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_task_params
      params.require(:daily_task).permit(:sort_order, :name, :frequency, :description, :syntax, :parameters, :status, :department, :manager)
    end
end
