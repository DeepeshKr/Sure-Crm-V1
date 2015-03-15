class ProductTrainingManualsController < ApplicationController
  before_action :set_product_training_manual, only: [:show, :edit, :update, :destroy]

  respond_to :html, :xml, :json

  def index
    @product_training_manuals = ProductTrainingManual.all
    respond_with(@product_training_manuals)
     #respond_with(@product_training_manuals.product_master)
    #redirect_to product_master_path(:id => params[:mobile], :called_to => params[:called_to])
  end

  def show
    respond_with(@product_training_manual)
  end
  
  def training
  if !params.blank?
     productvariantid = ProductList.where('id = ?', params[:id]).pluck(:product_variant_id).first
      
     @productid = ProductVariant.where('id = ?', productvariantid).pluck(:productmasterid).first

     @traininglist = ProductTrainingManual.where('productid = ?', @productid)
              
     if @traininglist.empty?
       @training = "No script for " + params[:id] + "product id " + @productid.to_s
       @heading = "Searched for " << @productid.to_s 
     end         
      
      @training =  "updated at " + DateTime.now.to_s 
      @heading = "No Script for " << @productid.to_s 

       @heading = ProductList.find(params[:id]).name
  
   end
     
  end
  
  def new
    @product_training_manual = ProductTrainingManual.new
    respond_with(@product_training_manual.product_master)
    
  end


  def edit
  end

  def create
    @product_training_manual = ProductTrainingManual.new(product_training_manual_params)
    @product_training_manual.save
    respond_with(@product_training_manual.product_master)
  end

  def update
    @product_training_manual.update(product_training_manual_params)
    respond_with(@product_training_manual.product_master)
  end

  def destroy
    @product_training_manual.destroy
    respond_with(@product_training_manual.product_master)
  end

  private
    def set_product_training_manual
      @product_training_manual = ProductTrainingManual.find(params[:id])
    end

    def product_training_manual_params
      params.require(:product_training_manual).permit(:productid, :name, :description, :quicknotes)
    end
end
