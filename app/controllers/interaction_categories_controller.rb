class InteractionCategoriesController < ApplicationController
  before_action :set_interaction_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @interaction_categories = InteractionCategory.all
    respond_with(@interaction_categories)
  end

  def show
    respond_with(@interaction_category)
  end

  def new
    @interaction_category = InteractionCategory.new
    respond_with(@interaction_category)
  end

  def edit
  end

  def create
    @interaction_category = InteractionCategory.new(interaction_category_params)
    @interaction_category.save
    respond_with(@interaction_category)
  end

  def update
    @interaction_category.update(interaction_category_params)
    respond_with(@interaction_category)
  end

  def destroy
    @interaction_category.destroy
    respond_with(@interaction_category)
  end

  private
    def set_interaction_category
      @interaction_category = InteractionCategory.find(params[:id])
    end

    def interaction_category_params
      params.require(:interaction_category).permit(:name, :sortorder, :employeeid, :resolutionhours)
    end
end
