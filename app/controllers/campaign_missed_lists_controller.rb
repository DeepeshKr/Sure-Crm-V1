class CampaignMissedListsController < ApplicationController
  before_action :set_campaign_missed_list, only: [:show, :edit, :update, :destroy]

  # GET /campaign_missed_lists
  # GET /campaign_missed_lists.json
  def index
    delete_irrelevant
    @campaign_missed_lists = CampaignMissedList.all.order("created_at DESC").paginate(:page => params[:page])
  end

  # GET /campaign_missed_lists/1
  # GET /campaign_missed_lists/1.json
  def show
  end

  # GET /campaign_missed_lists/new
  def new
    @campaign_missed_list = CampaignMissedList.new
  end

  # GET /campaign_missed_lists/1/edit
  def edit
  end

  # POST /campaign_missed_lists
  # POST /campaign_missed_lists.json
  def create
    @campaign_missed_list = CampaignMissedList.new(campaign_missed_list_params)

    respond_to do |format|
      if @campaign_missed_list.save
        format.html { redirect_to @campaign_missed_list, notice: 'Campaign missed list was successfully created.' }
        format.json { render :show, status: :created, location: @campaign_missed_list }
      else
        format.html { render :new }
        format.json { render json: @campaign_missed_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaign_missed_lists/1
  # PATCH/PUT /campaign_missed_lists/1.json
  def update
    respond_to do |format|
      if @campaign_missed_list.update(campaign_missed_list_params)
        format.html { redirect_to @campaign_missed_list, notice: 'Campaign missed list was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign_missed_list }
      else
        format.html { render :edit }
        format.json { render json: @campaign_missed_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaign_missed_lists/1
  # DELETE /campaign_missed_lists/1.json
  def destroy
    @campaign_missed_list.destroy
    respond_to do |format|
      format.html { redirect_to campaign_missed_lists_url, notice: 'Campaign missed list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def delete_irrelevant
      campaign_missed_lists = CampaignMissedList.where("campaign_playlist_id is NULL")
      campaign_missed_lists.each do |camp_miss|
        camp_miss.destroy
      end
    end
    def humanize secs
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{name}"
        end
      }.compact.reverse.join(' ')
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_missed_list
      @campaign_missed_list = CampaignMissedList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_missed_list_params
      params.require(:campaign_missed_list).permit(:product_list_id, :product_variant_id, :productmaster_id, :external_prod, :reason, :description, :time_diff, :order_time,
      :play_list_time, :order_id, :campaign_id, :campaign_playlist_id, :called_no, :customer_state, :media_id)
    end
    #  <td><%= link_to 'Edit', edit_campaign_missed_list_path(campaign_missed_list) %></td>
end
