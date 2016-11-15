class MediaController < ApplicationController
   before_action { protect_controllers(10) }
  before_action :set_medium, :dropdowns, only: [ :show, :edit, :update, :destroy]

  respond_to :html

  def index
  #Medium.recalculate_media_total_cost
  #recalculate_media_total_cost
    dropdowns
    @statelists = State.all
    @showall = true
    @media = Medium.all.order("updated_at DESC").limit(50).paginate(:page => params[:page])
    @inactivemedia = Medium.where(active:0).order("updated_at DESC").limit(50).paginate(:page => params[:page])
    if params[:telephone].present?
       @telephone = params[:telephone]
       @media = Medium.where("telephone like ? or dnis like ? ", "#{@telephone}%", "#{@telephone}%")
       .paginate(:page => params[:page])

        @inactivemedia = Medium.where(active:0).where(telephone: params[:telephone])
        .paginate(:page => params[:page])
    end
    if params.has_key?(:state)
       @media = Medium.where(state: params[:state]).paginate(:page => params[:page])
       @state = params[:state]
       @inactivemedia = Medium.where(active:0).where(state: params[:state]).paginate(:page => params[:page])
    end

    if params[:name].present?
       @media = Medium.where(dnis: params[:dnis]).order("updated_at DESC")
       .paginate(:page => params[:page])
       @name = params[:name]
       
       @inactivemedia = Medium.where(active:0).where(dnis: params[:dnis])
       .order("updated_at DESC").
       paginate(:page => params[:page])
    end
    if params[:name].present?
      @search = params[:name]
      @search = @search.upcase
      
      @media = Medium.where("name like ? or ref_name like ?", "%#{@search}%", "%#{@search}%")
      .order("updated_at DESC").paginate(:page => params[:page])
      
      @inactivemedia = Medium.where(active:0)
      .where("name like ? or ref_name like ?", "#{@search}%", "#{@search}%")
      .order("updated_at DESC")
      .paginate(:page => params[:page])
      
       @dnis = params[:dnis]
    end
    #@commission
    if params.has_key?(:commission)
       @media = Medium.where(media_commision_id: params[:commission]).paginate(:page => params[:page])
       @commission = params[:commission]
       @inactivemedia = Medium.where(active:0)
       .where(media_commision_id: params[:commission])
       .paginate(:page => params[:page])
    end
    if params.has_key?(:employee_id)
      
       @employee_id = params[:employee_id]
        @media = Medium.where(employee_id: @employee_id).paginate(:page => params[:page])
        
       @inactivemedia = Medium.where(active:0)
       .where(employee_id: @employee_id)
       .paginate(:page => params[:page])
    end
    if params[:showall].present?
      if params[:showall] = "true"
        @showall = "true"
         @media = Medium.all.order("name, updated_at DESC") #.paginate(:page => params[:page])
         # @inactivemedia = Medium.where(active:0).order("name, updated_at DESC") #.paginate(:page => params[:page])
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

  def all_hbn
    @media = Medium.where(media_group_id: 10000, active: true, media_commision_id: 10000)
    @inactivemedia = Medium.where(media_group_id: 10000, active: false, media_commision_id: 10000)
  end

  def show

    respond_with(@medium)
  end
  
  def switch_cdm
    #change the cdms to new ones
    no_of = 0
    
    @current_employee_id = params[:current_employee_id]
    @new_employee_id = params[:new_employee_id]
    if @new_employee_id.to_i == @current_employee_id.to_i
      flash[:error] = "You are attempting to replace by the same CDM!!!"
    
      return media_path(employee_id: @new_employee_id)
      
    else
      current_employees = Medium.where(employee_id: @current_employee_id)
      current_employees.each do |empl|
        # empl.update(employee_id: @new_employee_id)
        # update without validations
        empl.update_attribute('employee_id',@new_employee_id)
        no_of += 1
      end
    end
    
    flash[:notice] = "Updated #{no_of} media with the new employee details"
    
    redirect_to media_path(employee_id: @new_employee_id) and return
    
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
    recalculate_media_total_cost
    respond_with(@medium)
  end

  def update
    @medium.update(medium_params)
    recalculate_media_total_cost
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
      @states = Medium.select(:state).distinct.order(:state)
      @statelist = State.all
      @media_commission = MediaCommision.all
      @media_group = MediaGroup.all
    @employees = Employee.all.order("first_name").where(:employee_role_id => 10121) #.sort("employee_roles.sortorder desc")
    end
    def set_medium
      @medium = Medium.find(params[:id])
    end
    def recalculate_media_total_cost
      hbn_media_cost = Medium.where(media_group_id: 10000, active: true, media_commision_id: 10000).sum(:daily_charges).to_f

      hbn_list = MediaCostMaster.where(media_id: 11200) #.order("str_hr, str_min")
      hbn_list.each do |hbn|
       new_total = hbn_media_cost * hbn.slot_percent
       hbn.update(total_cost: new_total)
      end
      return "Total Cost Master for HBN is now divided by #{hbn_media_cost}"
    end
    def medium_params
      params.require(:medium).permit(:name, :telephone, :alttelephone, :state,
       :active, :corporateid, :description, :ref_name, :media_commision_id,
        :value, :media_group_id, :dnis, :channel, :slot, :daily_charges,
         :paid_correction, :employee_id, :dept, :agent_comm)
    end
end
