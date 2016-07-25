class StatesController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @states = State.all.order(:name)
    respond_with(@states)
  end

  def show
    respond_with(@state)
  end

  def new
    @state = State.new
    respond_with(@state)
  end

  def edit
   
  end
  def edit_all
    @states = State.all.order(:name)
  end
  def create
    @state = State.new(state_params)
    @state.save
    respond_with(@state)
  end

  def update_all
    updates = " "
    params['state'].keys.each do |id|
          @state = State.find(id.to_i)
        updates += @state.short_code
         @state.update_attributes(params['state'][id])
        end
          flash[:success] = "Updated : #{updates}"
    redirect_to(states_url)
  end

  def update
    @state.update(state_params)
    respond_with(@state)
  end

  def destroy
    @state.destroy
    respond_with(@state)
  end

  private
    def set_state
      @state = State.find(params[:id])
    end

    def state_params
      params.require(:state).permit(:name, :short_code)
    end
end
