class InteractionUsersController < ApplicationController
  before_action :set_interaction_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @interaction_users = InteractionUser.all
    respond_with(@interaction_users)
  end

  def show
    respond_with(@interaction_user)
  end

  def new
    @interaction_user = InteractionUser.new
    respond_with(@interaction_user)
  end

  def edit
  end

  def create
    @interaction_user = InteractionUser.new(interaction_user_params)
    @interaction_user.save
    respond_with(@interaction_user)
  end

  def update
    @interaction_user.update(interaction_user_params)
    respond_with(@interaction_user)
  end

  def destroy
    @interaction_user.destroy
    respond_with(@interaction_user)
  end

  private
    def set_interaction_user
      @interaction_user = InteractionUser.find(params[:id])
    end

    def interaction_user_params
      params.require(:interaction_user).permit(:name)
    end
end
