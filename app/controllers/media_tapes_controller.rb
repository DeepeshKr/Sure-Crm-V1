class MediaTapesController < ApplicationController
  before_action :set_media_tape, only: [:show, :edit, :update, :destroy]
  before_action :dropdown, only: [:new, :create, :edit, :update, :destroy]
  before_action :last_ext_tape_id, only: [:new]
  
  respond_to :html, :xml, :json

  def index
    @media_tapes = MediaTape.all
    respond_with(@media_tapes)
  end

  def show
    respond_with(@media_tape)
  end

  def new
   #find_sort_order() 
          @rand = rand(10000 .. 99999) # this generator a number between 1 to 50
   
    @media_tape = MediaTape.new(tape_ext_ref_id: last_ext_tape_id, duration_secs: 0,
      unique_tape_name: @rand)
    respond_with(@media_tape)
  end

  def edit
  end

  def create  
          
          release_date = Date.strptime(media_tape_params[:release_date], '%m/%d/%Y')
        if media_tape_params[:unique_tape_name].empty?
          rand = rand(10000 .. 99999) # this generator a number between 1 to 50
          media_tape_params[:unique_tape_name] = rand
        end

          tapename = media_tape_params[:name]
          tapename = tapename << params[:file_extension]
          media_tape_params[:name] = tapename

          @media_tape = MediaTape.create(name: tapename,
            description: tapename,
            release_date: release_date,
            duration_secs: media_tape_params[:duration_secs], 
            tape_ext_ref_id: media_tape_params[:tape_ext_ref_id],
            unique_tape_name: media_tape_params[:unique_tape_name],
            media_id: media_tape_params[:media_id],
            product_variant_id: media_tape_params[:product_variant_id],
            media_tape_head_id: media_tape_params[:media_tape_head_id],
            sort_order: media_tape_params[:sort_order])
          
        if @media_tape.valid?
          flash[:notice] = "The tape details have been saved, now you can add these in campaigns."
          @media_tape.save
        else
           flash[:notice] = @media_tape.errors.full_messages.join("<br/>")
        end
    
        respond_with(@media_tape.media_tape_head)
  end

  def update
    @media_tape.update(media_tape_params)
    respond_with(@media_tape.media_tape_head)
  end

  def destroy
    @media_tape.destroy
    respond_with(@media_tape.media_tape_head)
  end

  #get "mediatapesforproducts" => 'media_tapes#productwise'
  def productwise
    @media_tapes = MediaTape.where("product_variant_id is null")
        @name = @media_tapes.first.name
        @internaltapeid = @media_tapes.first.unique_tape_name
        @filename = @media_tapes.first.name
        @duration_secs = @media_tapes.first.duration_secs
        @cost = 0
    #if params.has_key?[:product_variant_id] 
   if MediaTape.where("product_variant_id = ?", params[:product_variant_id]).present?    
        @media_tapes = MediaTape.where("product_variant_id = ?", params[:product_variant_id])
        @name = @media_tapes.first.name
        @internaltapeid = @media_tapes.first.unique_tape_name
        @filename = @media_tapes.first.name
        @duration_secs = @media_tapes.first.duration_secs
        @cost = 0
    end  
  end
 
# get "addonproducts" => 'product_master_add_ons#productlist'
  def product_lists
     # product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
     #  product_variants = ProductVariant.where("activeid = ? and product_sell_type_id < ?", 10000, 10002).where(productmasterid: product_masters).pluck("id")
     # @product_lists = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants)
    #@productlists = ProductList.all
    @product_master_add_ons = nil
    if ProductList.find(params[:product_list_id]).present?
    productvariantid = ProductList.where('active_status_id = ?',  10000.find(params[:product_list_id]).product_variant_id
      id = params[:product_list_id]
      if ProductVariant.where("activeid = ?",10000).find(productvariantid).present?
          productid = ProductVariant.where("activeid = ?",10000).find(productvariantid).productmasterid
          if ProductMasterAddOn.where(product_master_id: productid).present? 
          @productlists = ProductMasterAddOn.where(product_master_id: productid)
           else
          @product_master_add_ons = nil
          end
      end
    end  
  
  end

  def tape_details
     @name = nil
        @internaltapeid = nil
        @filename = nil
        @duration_secs = nil
        @cost = 0
    if MediaTape.find(params[:tape_id]).present? 
     @media_tape = MediaTape.find(params[:tape_id])
        @name = @media_tape.name
        @internaltapeid = @media_tape.unique_tape_name
        @filename = @media_tape.name
        @duration_secs = @media_tape.duration_secs
        @cost = 0
    end
  end

  private
    def set_media_tape
      @media_tape = MediaTape.find(params[:id])
    end
    def dropdown
     @medialist = Medium.where('media_commision_id = ?',  10000).order('name')
     @productvariantlist = ProductVariant
     .where('product_variants.activeid = ? and product_variants.product_sell_type_id < ?', 10000, 10002).joins(:product_master)
     .where("product_masters.productactivecodeid = ?", 10000)

    
#@file_parts = [{"name"=>"Single", "id"=>"0"}, {"name"=>"Two", "id"=>"2"}]
    # @file_extenstion = [{"name"=>"avi", "id"=>"avi"}, {"name"=>"mcx", "id"=>"mcx"}]
    end

    def media_tape_params
      params.require(:media_tape).permit(:name,:release_date, :duration_secs, 
        :tape_ext_ref_id, :unique_tape_name, 
        :media_id, :product_variant_id, :description, :file_parts, 
        :file_extenstion, :media_tape_head_id, :sort_order)

    end
    def last_ext_tape_id
     
      if MediaTape.exists?
        media_tape = MediaTape.last
          return @last_tape_id = media_tape.tape_ext_ref_id + 1
      else
        return @last_tape_id =  1

      end
    
    end
    def find_sort_order(media_tape_head_id)  
        media_tape = MediaTape.where('media_tape_head_id = ?', media_tape_head_id).order("sort_order")
      if media_tape.present?
        if media_tape.last.sort_order.present?
          return @sort_order = media_tape.last.sort_order.to_i + 1
        else
          return @sort_order =  1
        end
          
      else
        return @sort_order =  1

      end
    
    end
end
