class MediaTapeHeadsController < ApplicationController
  before_action :set_media_tape_head, only: [:show, :edit, :update, :destroy]
  before_action :last_ext_tape_id, only: [:show]
  # GET /media_tape_heads
  # GET /media_tape_heads.json
  def index
    @media_tape_heads = MediaTapeHead.all
  end

  # GET /media_tape_heads/1
  # GET /media_tape_heads/1.json
  def show
   @sort_order = find_sort_order(params[:id])
    @rand = rand(10000 .. 99999)
     @medialist = Medium.where('media_commision_id = ?',  10000).order('name') 

    @media_tapes = MediaTape.where("media_tape_head_id = ?", params[:id]).order(:sort_order)

    @new_name || @media_tape_head.name.to_s.split('.')[0]

    @media_tape = MediaTape.new(media_tape_head_id: @media_tape_head.id,
     product_variant_id: @media_tape_head.product_variant_id,
     name: @new_name, 
     tape_ext_ref_id: @last_tape_id, duration_secs: 0,
      unique_tape_name: @rand, sort_order: @sort_order)
  end

  def update_tapes
    #http://pullmonkey.com/2012/08/11/dynamic-select-boxes-ruby-on-rails-3/
    media_tapes = MediaTapeHead.where('product_variant_id = ?' ,params[:product_variant_id])
    #if media_tapes.present?
    # map to name and id for use in our options_for_select
    @media_tape_head_list = media_tapes.map{|a| [a.name, a.id]}.insert(0, "Select an Media Tape")
    @media_tapes = nil
    #end
  end

  def tape_list

     @media_tapes = MediaTape.where("media_tape_head_id = ?", params[:media_tape_head_id]).order(:sort_order)
  end

  # GET /media_tape_heads/new
  def new
    @media_tape_head = MediaTapeHead.new
  end

  # GET /media_tape_heads/1/edit
  def edit
  end 

  # POST /media_tape_heads
  # POST /media_tape_heads.json
  def create
    tapename = media_tape_head_params[:name]
        if params[:file_parts].to_i > 0
          tapename = tapename << "_" << params[:file_parts].to_s
        end
    tapename = tapename << params[:file_extension]
    media_tape_head_params[:name] = tapename

    @media_tape_head = MediaTapeHead.new(media_tape_head_params)

    respond_to do |format|
      if @media_tape_head.save
        format.html { redirect_to @media_tape_head, notice: 'Media tape head was successfully created.' }
        format.json { render :show, status: :created, location: @media_tape_head }
      else
        format.html { render :new }
        format.json { render json: @media_tape_head.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media_tape_heads/1
  # PATCH/PUT /media_tape_heads/1.json
  def update
    tapename = media_tape_head_params[:name]
        if params[:file_parts].to_i > 0
          tapename = tapename << "_" << params[:file_parts].to_s
        end
    tapename = tapename << params[:file_extension]
    media_tape_head_params[:name] = tapename

    respond_to do |format|
      if @media_tape_head.update(media_tape_head_params)
        format.html { redirect_to @media_tape_head, notice: 'Media tape head was successfully updated.' }
        format.json { render :show, status: :ok, location: @media_tape_head }
      else
        format.html { render :edit }
        format.json { render json: @media_tape_head.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media_tape_heads/1
  # DELETE /media_tape_heads/1.json
  def destroy
    @media_tape_head.destroy
    respond_to do |format|
      format.html { redirect_to media_tape_heads_url, notice: 'Media tape head was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media_tape_head
      @media_tape_head = MediaTapeHead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_tape_head_params
      params.require(:media_tape_head).permit(:name, :description, :product_variant_id)
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
          return @sort_order = media_tape.last.sort_order.to_i + 1
      else
        return @sort_order =  1

      end
    
    end

    
end
