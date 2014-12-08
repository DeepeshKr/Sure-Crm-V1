class EmploymentTypesController < ApplicationController
  before_action :set_employment_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @employment_types = EmploymentType.all
    respond_with(@employment_types)
  end

  def show
    respond_with(@employment_type)
  end

  def new
    @employment_type = EmploymentType.new
    respond_with(@employment_type)
  end

  def edit
  end

  def create
    @employment_type = EmploymentType.new(employment_type_params)
    @employment_type.save
    respond_with(@employment_type)
  end

  def update
    @employment_type.update(employment_type_params)
    respond_with(@employment_type)
  end

  def destroy
    @employment_type.destroy
    respond_with(@employment_type)
  end

  private
    def set_employment_type
      @employment_type = EmploymentType.find(params[:id])
    end

    def employment_type_params
      params.require(:employment_type).permit(:name, :sortorder)
    end
end
