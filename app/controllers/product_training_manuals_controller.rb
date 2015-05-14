class ProductTrainingManualsController < ApplicationController
  before_action :set_product_training_manual, only: [:show, :edit, :update, :destroy]

  respond_to :html, :xml, :json

  def index
    if params[:productid].present?
       @product_training_manuals = ProductTrainingManual.where("productid = ?", params[:productid])
       @productid = params[:productid]
       @trainingfor = ProductMaster.find(params[:productid]).productname + " Training"
    
        @product_training_manual = ProductTrainingManual.new(productid: @productid)
    
    respond_with(@product_training_manuals, @product_training_manual)
  else
    @productid = nil
     @product_training_manuals = ProductTrainingManual.last(20)
     @trainingfor = "Showing recently added 20 "
    respond_with(@product_training_manuals)
    end
   
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

        productlist = ProductList.find(params[:id])
         @heading = productlist.productinfo
        
         @basic =  productlist.price
         #@shipping =  productlist.shipping.to_i.to_s
         
         @cod =  productlist.codcharges.to_i.to_s
         @mahcod =  productlist.maharastracodextra.to_i.to_s
         #@servicetx =  productlist.servicetax.to_i.to_s

         @cc =  productlist.creditcardcharges.to_i.to_s
         @mahcc =  productlist.maharastraccextra.to_i.to_s

     end
     
  end

  def training_text
    if !params.blank?
    @searchvalue = params[:searchvalue]
     @searchvalue =  @searchvalue.upcase
      
      @training =  "updated at " + DateTime.now.to_s 
      @heading = "No Script for " << @searchvalue

       productlists = ProductList.where(active_status_id: 10000).where("name like ? ", "#{@searchvalue}%").pluck(:product_variant_id).first
       if productlists.present?
          #exiting

         #productvariantid = ProductList.where('id = ?', params[:id]).pluck(:product_variant_id).first
          
         @productid = ProductVariant.where('id = ?', productlists).pluck(:productmasterid).first

         @traininglist = ProductTrainingManual.where('productid = ?', @productid)
                  
          product_list_id = productlists
         if @traininglist.empty?
           @training = "No script for " + product_list_id.to_s + "product id " + @productid.to_s
           @heading = "Searched for " << @searchvalue
         end         
          
          productlist = ProductList.find(product_list_id)

          @heading = productlist.productinfo
          
          @basic =  productlist.price
           #@shipping =  productlist.shipping.to_i.to_s
           
          @cod =  productlist.codcharges.to_i.to_s
          @mahcod =  productlist.maharastracodextra.to_i.to_s
           #@servicetx =  productlist.servicetax.to_i.to_s

          @cc =  productlist.creditcardcharges.to_i.to_s
          @mahcc =  productlist.maharastraccextra.to_i.to_s
       end
     end
  end
  
  def new
    @product_training_manual = ProductTrainingManual.new
    respond_with(@product_training_manual.product_master)
    
  end


  def edit
  end

  def inlinecreate
    @product_training_manual = ProductTrainingManual.new(product_training_manual_params)
    @product_training_manual.save
    redirect_to producttrainig(:productid => @product_training_manual.productid)
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
