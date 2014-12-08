class SalutesController < ApplicationController
  before_action :set_salute, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @salutes = Salute.all
    respond_with(@salutes)
  end

  def show
    respond_with(@salute)
  end

  def new
    @salute = Salute.new
    respond_with(@salute)
  end

  def edit
  end

  def create
    @salute = Salute.new(salute_params)
    @salute.save
    respond_with(@salute)
  end

  def update
    @salute.update(salute_params)
    respond_with(@salute)
  end

  def destroy
    @salute.destroy
    respond_with(@salute)
  end

  private
    def set_salute
      @salute = Salute.find(params[:id])
    end

    def salute_params
      params.require(:salute).permit(:name)
    end
end
