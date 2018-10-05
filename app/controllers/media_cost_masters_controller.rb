class MediaCostMastersController < ApplicationController
  before_action { protect_controllers(8) }
  before_action :set_media_cost_master, only: [:show, :edit, :update, :destroy]
  before_action :dropdown, only: [:index, :new, :destroy]

  respond_to :html

  def index
    # @media_cost_masters = MediaCostMaster.order('updated_at DESC').limit(10)
    flash[:success] = "Media costs updated"
    MediaCostMaster.recalculate_media_total_cost
     @summary = 'Recently updated Masters'
     @totalmediacost = 0
      @showhbn = 1
      #@showpvt = 1
     @media_cost_master = MediaCostMaster.new
    # respond_with(@media_cost_masters)
    # :search
    if params.has_key?(:media_id)
      @media_id = params[:media_id]
      #show existing shows for the media selected
      @media_cost_masters = MediaCostMaster.where(media_id: params[:media_id])
      #get total cost if media is HBN
      if (Medium.where('id = ? and media_group_id = ? ', params[:media_id], 10000)).present?
        #hide pvt channel form
        hbn_media_costs
        @showhbn = 1
        @showpvt = 0

      else
        #hide hbn form
        @showhbn = 0
        @showpvt = 1

      end

    end
    @hbn_list = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
    @pvt_channel = MediaCostMaster.where('media_id <> 11200').order("media_id, str_hr, str_min")
  end

  def hbn_cost_summary
    @from_date = Date.current - 30.days #30.days
    @to_date = Date.current
    if params[:from_date].present?

      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d").beginning_of_day - 330.minutes
      #@from_date = @from_date
      @to_date = @from_date.end_of_day - 330.minutes

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d").end_of_day - 330.minutes
      end

      @to_date = @to_date
    end

    @hbn_cost_list = MediaCostMaster.calculate_average_cost(@from_date, @to_date)
  end

  def get_costs
    @begin_hr = params[:begin_hr]
    @begin_min = params[:begin_min]
    @begin_sec = params[:begin_sec]
    @total_secs = params[:total_secs]

    #show_cost_of_playlist start_hour, start_min, start_sec, play_duration_sec
    return if @begin_hr.blank?
    return if @begin_min.blank?
    return if @begin_sec.blank?
    return if @total_secs.blank?


    media_cost_check = MediaCostMaster.new
    @media_cost =  media_cost_check.show_cost_of_playlist @begin_hr.to_i, @begin_min.to_i, @begin_sec.to_i, @total_secs.to_i

    #attr_accessor :loops, :cost_details, :cost_cal_per_sec, :secs_used, :secs_bal, :loop_cost

  end

  def show
    respond_with(@media_cost_master)
  end

  def new
    @showpvt = 1
    @showhbn = 1
    @media_cost_master = MediaCostMaster.new
    respond_with(@media_cost_master)
  end

  def edit
    @totalmediacost = 0
    @showhbn = 1
    @showpvt = 1
    @media_id = @media_cost_master.media_id
    
   # @:slot_percent

    #get total cost if media is HBN
    if (Medium.where('media_group_id = ? and id = ?', 10000, @media_id)).present?
       #show existing shows for the media selected
      @hbnmedialist = Medium.where('id = 11200')
      #hide pvt channel form
      hbn_media_costs
      @showhbn = 1
      @showpvt = 0
    else
      #hide hbn form
      @pvtmedialist = Medium.where('id = ?',  @media_id)
      @showhbn = 0
      @showpvt = 1

    end
  end

  def create

    @media_id = media_cost_master_params[:media_id]
    @media_cost_master = MediaCostMaster.new(media_cost_master_params)
    hbn_total_cost = 0
     if params.has_key?(:hbn_total_cost)
        hbn_total_cost = params[:hbn_total_cost]
      @media_cost_master.update(total_cost: hbn_total_cost.to_f * media_cost_master_params[:slot_percent].to_f)
        #difference in seconds     :str_hr, :str_min, :end_hr, :end_min,
       str_hr = media_cost_master_params[:str_hr].to_i
       str_min = media_cost_master_params[:str_min].to_i
       end_hr = media_cost_master_params[:end_hr].to_i
       end_min = media_cost_master_params[:end_min].to_i
       if end_hr == 0 && end_min == 0
          end_hr = 24
       end
       duration_secs = (end_hr*60*60 + end_min*60) - (str_hr*60*60 + str_min*60)
        @media_cost_master.update(duration_secs: duration_secs)
        @media_cost_master.update(name: "Cost for time between #{str_hr}:#{str_min} and #{end_hr}: #{end_min} ")

     end

      #respond_with(@media_cost_master)
      if @media_cost_master.valid?
          flash[:success] = "Media Cost successfully added "
           @media_cost_master.save
            @media_cost_master.update(total_cost: hbn_total_cost.to_f * media_cost_master_params[:slot_percent].to_f)
      else
          flash[:error] = @media_cost_master.errors.full_messages.join("<br/>")
      end
       #redirect_to media_cost_masters_path(:media_id => @media_id)

       redirect_to media_cost_masters_path
  end

  def update

     @media_id = media_cost_master_params[:media_id]
      @media_cost_master.update(media_cost_master_params)
    hbn_total_cost = 0
     if params.has_key?(:hbn_total_cost)
        hbn_total_cost = params[:hbn_total_cost]
      @media_cost_master.update(total_cost: hbn_total_cost.to_f * media_cost_master_params[:slot_percent].to_f)
        #difference in seconds     :str_hr, :str_min, :end_hr, :end_min,
       str_hr = media_cost_master_params[:str_hr].to_i
       str_min = media_cost_master_params[:str_min].to_i
       end_hr = media_cost_master_params[:end_hr].to_i
       end_min = media_cost_master_params[:end_min].to_i
       if end_hr == 0 && end_min == 0
          end_hr = 24
       end
       duration_secs = (end_hr*60*60 + end_min*60) - (str_hr*60*60 + str_min*60)
        @media_cost_master.update(duration_secs: duration_secs)
        @media_cost_master.update(name: "Cost for time between #{str_hr}:#{str_min} and #{end_hr}: #{end_min} ")
     end
     if @media_cost_master.valid?
          flash[:success] = "Media Cost successfully updated "
           #@media_cost_master.save
        else
          flash[:error] = @media_cost_master.errors.full_messages.join("<br/>")
      end
       redirect_to media_cost_masters_path(:media_id => @media_id)
    #respond_with(@media_cost_master)
  end

  def destroy
    @media_cost_master.destroy
    redirect_to media_cost_masters_path(:media_id => @media_cost_master.media_id)
    #respond_with(@media_cost_master)
  end

  private
  def recalculate_media_total_cost
    fixed_pre_paid = [10000, 10045]
    hbn_media_cost = Medium.where(media_group_id: 10000, active: true, media_commision_id: fixed_pre_paid)
    .sum(:daily_charges).to_f

    hbn_list = MediaCostMaster.where(media_id: 11200) #.order("str_hr, str_min")
    hbn_list.each do |hbn|
     new_total = hbn_media_cost * hbn.slot_percent
     hbn.update(total_cost: new_total)
    end
    return "Total Cost Master for HBN is now divided by #{hbn_media_cost}"
  end

  def set_media_cost_master
      @media_cost_master = MediaCostMaster.find(params[:id])
  end

  def hbn_media_costs
    fixed_pre_paid = [10000, 10045]
    @hbn_media_costs  = Medium.where(media_group_id: 10000, active: true, media_commision_id: fixed_pre_paid).sum(:daily_charges).to_f

  end

  def dropdown
    #.where(media_group_id: 10000)
    if params.has_key?(:media_id)
     @pvtmedialist = Medium.where('id = ?',  params[:media_id])
    else
     @pvtmedialist = Medium.where('media_commision_id = ?',  10000).where('media_group_id IS NULL or media_group_id <> 10000').order('name')
    end

      @hbnmedialist = Medium.where('media_commision_id = ?',  10000).where('id = 11200').order('name')
   #@medialist = Medium.where('media_commision_id = ? AND (media_group_id <> ? OR media_group_id IS NULL)',10000,  10000).order('name')
  end

  def media_cost_master_params
      params.require(:media_cost_master).permit(:name, :duration_secs,
        :total_cost, :media_id, :str_hr, :str_min,
         :str_sec, :end_hr, :end_min, :end_sec,
         :description, :slot_percent)
  end
end
