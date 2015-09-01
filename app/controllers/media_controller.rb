class MediaController < ApplicationController
  before_action :set_medium, :dropdowns, only: [ :show, :edit, :update, :destroy]

  respond_to :html

  def index
    dropdowns
     @statelists = State.all
    @showall = true
     @media = Medium.all.order("updated_at DESC").limit(50).paginate(:page => params[:page])
      @inactivemedia = Medium.where(active:0).order("updated_at DESC").limit(50).paginate(:page => params[:page])
    if params[:telephone].present?
       @media = Medium.where(telephone: params[:telephone]).paginate(:page => params[:page])
       @telephone = params[:telephone]
        @inactivemedia = Medium.where(active:0).where(telephone: params[:telephone]).paginate(:page => params[:page])
    end
     if params.has_key?(:state)
       @media = Medium.where(state: params[:state]).paginate(:page => params[:page])
       @state = params[:state]
       @inactivemedia = Medium.where(active:0).where(state: params[:state]).paginate(:page => params[:page])
    end
    if params[:dnis].present?
       @media = Medium.where(dnis: params[:dnis]).order("updated_at DESC")
       @dnis = params[:dnis]
       @inactivemedia = Medium.where(active:0).where(dnis: params[:dnis]).order("updated_at DESC")
    end
    if params[:name].present?
      @search = params[:name]
      @search = @search.upcase
      @media = Medium.where("name like ? or ref_name like ?", "#{@search}%", "#{@search}%").order("updated_at DESC").paginate(:page => params[:page])
      @inactivemedia = Medium.where(active:0).where("name like ? or ref_name like ?", "#{@search}%", "#{@search}%").order("updated_at DESC").paginate(:page => params[:page])
       @dnis = params[:dnis]
    end
    #@commission
     if params.has_key?(:commission)
       @media = Medium.where(media_commision_id: params[:commission]).paginate(:page => params[:page])
       @commission = params[:commission]
       @inactivemedia = Medium.where(active:0).where(media_commision_id: params[:commission]).paginate(:page => params[:page])
    end
    
      if params[:showall].present?
        if params[:showall] = "true"
          @showall = "true"
           @media = Medium.all.order("name, updated_at DESC").paginate(:page => params[:page])
           @inactivemedia = Medium.where(active:0).order("name, updated_at DESC").paginate(:page => params[:page])
        respond_to do |format|
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"media-list\""
            headers['Content-Type'] ||= 'text/csv'
            
          end
        end
        end
      end
   
     
  end

  def show
    
    respond_with(@medium)
  end

  def new
    dropdowns
    @medium = Medium.new
    respond_with(@medium)
  end

  def edit
    
    dropdowns
    if  params[:new_channel].present?
        #code
        new_name = params[:new_channel]
        old_name = @medium.name
        @medium.name = new_name
       channel, slot = new_name.split(':')
       
       if channel.present?
        #code
        @medium.channel = channel.strip
       end
              
       if slot.present?
        #code
         @medium.slot = slot.strip
       end
            
       @change_name = "Click on update to change channel name from #{old_name} to #{new_name}"
    end
    
    
  end

  def create
    @medium = Medium.new(medium_params)
    @medium.save
    respond_with(@medium)
  end

  def update
    @medium.update(medium_params)
    if params[:next].present?
      if params[:next] == "next"
      new_id = params[:id]
        if Medium.where('id > ?', params[:id]).present?
          @new_medium = Medium.where('id > ?', params[:id]).first
         return redirect_to edit_medium_path(@new_medium) 
        else
          flash[:error] = "You have reached last media <br/>"
        end
       end   
    end
      respond_with(@medium)
  
  end

  def destroy
    @medium.destroy
    respond_with(@medium)
  end

  private
    def dropdowns
      @statelist = State.all
      @media_commission = MediaCommision.all
      @media_group = MediaGroup.all
    @employees = Employee.all.order("first_name").joins(:employee_role) #.sort("employee_roles.sortorder desc")
    end
    def set_medium
      @medium = Medium.find(params[:id])
    end
 
    def medium_params
      params.require(:medium).permit(:name, :telephone, :alttelephone, :state,
       :active, :corporateid, :description, :ref_name, :media_commision_id, 
        :value, :media_group_id, :dnis, :channel, :slot, :daily_charges,
         :paid_correction, :employee_id)
    end
end
