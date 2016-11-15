class MediaCostMaster < ActiveRecord::Base
# validates :name, presence: true
# validates :total_cost, presence: true
# validates :duration_secs, presence: true
attr_accessor :loops, :cost_details, :cost_cal_per_sec, :secs_used, :secs_bal, :loop_cost, :average_cost

	def media_tape_type
		(self.name + " Min: " + (self.duration_secs / 60).to_s + " Rs: " + total_cost.to_s )
	end
belongs_to :medium, foreign_key: "media_id"

	def cost_segment
    return self.total_cost.to_s + " - " + (self.slot_percent * 100).to_s + "%" + " - (" + (self.str_hr).to_s + ":"  + (self.str_min).to_s  + "-" + (self.end_hr).to_s + ":"  + (self.end_min).to_s + ")"
	end
	# after_create :recalculate_media_total_cost
	# after_update :recalculate_media_total_cost
	def self.start_secs
		(self.str_hr * 60 * 60) + (self.str_min * 60) + (self.str_sec)
	end

	def self.end_secs
		(self.end_hr * 60 * 60) + (self.end_min * 60) + (self.end_sec)
	end
  
  def self.calculate_average_cost start_date, end_date
    #calculate the cost between dates from campaign playlist
    #:str_hr, :str_min, :str_sec, :end_hr, :end_min, :end_sec,
    # campaign_playlist_fields :start_hr, :start_min, :start_sec, :end_hr, :end_min, :end_sec, :cost, :for_date
    hbn_cost_average = []
    hbn_list = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
        
    hbn_list.each do |hbn|
      
      total_cost = CampaignPlaylist.where("TRUNC(for_date) >= ? and TRUNC(for_date) <= ? ", start_date, end_date)
      .where("start_hr >= ? and start_min >= ? and end_hr <= ? and end_min <= ?", hbn.str_hr, hbn.str_min, hbn.end_hr, hbn.end_min).sum(:cost)
      
      no_of_days = (end_date.to_date - start_date.to_date).to_i
      # CampaignPlaylist.where("TRUNC(for_date) >= ? and TRUNC(for_date) <= ? ", start_date, end_date)
  #     .where("start_hr >= ? and start_min >= ? and end_hr <= ? and end_min <= ?", hbn.str_hr, hbn.str_min, hbn.end_hr, hbn.end_min).count()
      
      average_cost = total_cost / no_of_days
      
      media_cost_average = MediaCostMaster.new
      media_cost_average.name = hbn.name #"#{hbn.name} when calculated for cost #{total_cost} no of #{no_of_days}"
      media_cost_average.str_hr = hbn.str_hr
      media_cost_average.str_min = hbn.str_min
      media_cost_average.str_sec = hbn.str_sec
      media_cost_average.end_hr = hbn.end_hr
      media_cost_average.end_min = hbn.end_min
      media_cost_average.end_sec = hbn.end_sec
      media_cost_average.duration_secs = hbn.duration_secs
      media_cost_average.starting_sec = hbn.starting_sec
      media_cost_average.ending_sec = hbn.ending_sec
      media_cost_average.cost_per_sec = hbn.cost_per_sec
      media_cost_average.slot_percent = hbn.slot_percent
      media_cost_average.total_cost = hbn.total_cost
      media_cost_average.media_id = hbn.media_id
      
      media_cost_average.average_cost = average_cost.round(2)
      
      hbn_cost_average << media_cost_average
    end
    
    return hbn_cost_average
    
  end
  
	def self.recalculate_media_total_cost
		hbn_media_cost = Medium.where(media_group_id: 10000, active: true, media_commision_id: 10000).sum(:daily_charges).to_f

		hbn_list = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
		hbn_list.each do |hbn|
		 new_total = hbn_media_cost * hbn.slot_percent
		 hbn.update(total_cost: new_total)
		 hbn.update(starting_sec: ((hbn.str_hr * 60 * 60)||0) + ((hbn.str_min * 60) || 0) + (hbn.str_sec|| 0))
		 hbn.update(ending_sec: ((hbn.end_hr * 60 * 60)||0) + ((hbn.end_min * 60)||0) + (hbn.end_sec||0))
		 hbn.update(cost_per_sec: (hbn.total_cost.to_f / hbn.duration_secs.to_f).to_f)
		end

	end

	def self.cost_of_playlist start_hour, start_min, start_sec, play_duration_sec
    
    orginal_play_duration_sec = play_duration_sec
		return 0 if (play_duration_sec >= 86400)
		return 0 if (start_hour > 23 || start_hour < 0)
		return 0 if (start_min > 59 || start_min < 0)
		return 0 if (start_sec > 59 || start_sec < 0)
		total_cost_of_playlist = 0.0
		start_secs = (start_hour * 60 * 60) + (start_min * 60) + (start_sec)
		#end_secs = start_secs + duration_sec
		#check the pricing for start secs
    
		max_loop = 0
		loop_details = []
		balance_secs = play_duration_sec + start_secs
		total_cost_of_playlist = 0
    
		while balance_secs > 0  do
			start_costs = MediaCostMaster.where("starting_sec <= ?", start_secs).order("starting_sec DESC")
			loop_details << "#{start_costs.first.name} starting at #{start_costs.first.starting_sec} ending at #{start_costs.first.ending_sec} start sec is #{start_secs} duration of tape is #{play_duration_sec} where balance is #{balance_secs}"
      
      if start_costs.first.starting_sec < 84600 #if less than 23:30
        ending_secs = start_costs.first.ending_sec 
      else 
        ending_secs = 86400 # if more than 23:30 use this
      end
     # puts "Loop Start #{max_loop} balance #{balance_secs} start at #{start_secs}"
      
			if (balance_secs <= ending_secs)
				calculate_secs = play_duration_sec #balance_secs - start_costs.first.starting_sec
			#	 puts "Loop #{max_loop} LOWER: #{balance_secs} calculate secs #{calculate_secs}"
				balance_secs = 0
			else

				calculate_secs = ending_secs - start_secs
        if calculate_secs < 0
          ending_secs = 86400 #23:59:59 or 86400
        end
				play_duration_sec -= calculate_secs
				balance_secs = ending_secs + play_duration_sec
				start_secs = start_costs.first.ending_sec
			#	 puts "Loop #{max_loop} HIGHER: Calculated: #{calculate_secs} Balance: #{balance_secs}"
			end

			total_cost_of_playlist += calculate_secs * start_costs.first.cost_per_sec.to_f
			# puts "Loop #{max_loop}: Secs #{calculate_secs} for rate #{start_costs.first.cost_per_sec.to_f} #{calculate_secs * start_costs.first.cost_per_sec.to_f}"
			# # puts "Loop End #{max_loop} balance #{balance_secs} calculated sec #{calculate_secs} total costs #{total_cost_of_playlist}"
			 max_loop += 1 #|| max_loop = 0 if balance_secs > 0
		end
		# return "Final Cost is #{total_cost_of_playlist} in #{max_loop} loops "
		return total_cost_of_playlist
  end

	def show_cost_of_playlist start_hour, start_min, start_sec, play_duration_sec
    
		return 0 if (play_duration_sec >= 86400)
		return 0 if (start_hour > 23 || start_hour < 0)
		return 0 if (start_min > 59 || start_min < 0)
		return 0 if (start_sec > 59 || start_sec < 0)
		total_cost_of_playlist = 0.0
		start_secs = (start_hour * 60 * 60) + (start_min * 60) + (start_sec)
		#end_secs = start_secs + duration_sec
		#check the pricing for start secs
		max_loop = 0
		loop_details = []
		balance_secs = play_duration_sec + start_secs
		total_cost_of_playlist = 0

		while balance_secs > 0  do
			media_cost_show = MediaCostMaster.new
			#:loops, :cost_details, :cost_cal_per_sec, :secs_used, :secs_bal
			start_costs = MediaCostMaster.where("starting_sec <= ?", start_secs).order("starting_sec DESC")
			# loop_details << "#{start_costs.first.name} starting at #{start_costs.first.starting_sec} ending at #{start_costs.first.ending_sec} checked for lower than #{start_secs}"
			#
			# puts "Loop Start #{max_loop} balance #{balance_secs} start at #{start_secs}"
      
      if start_costs.first.starting_sec < 84600 #if less than 23:30
        ending_secs = start_costs.first.ending_sec 
      else 
        ending_secs = 86400 # if more than 23:30 use this
      end
     # puts "Loop Start #{max_loop} balance #{balance_secs} start at #{start_secs}"
      
			if (balance_secs <= ending_secs)
				calculate_secs = play_duration_sec #balance_secs - start_costs.first.starting_sec
			#	 puts "Loop #{max_loop} LOWER: #{balance_secs} calculate secs #{calculate_secs}"
				balance_secs = 0
			else
				calculate_secs = ending_secs - start_secs
        if calculate_secs < 0
          ending_secs = 86400 #23:59:59 or 86400
        end
        
				play_duration_sec -= calculate_secs
				balance_secs = ending_secs + play_duration_sec
				start_secs = start_costs.first.ending_sec

			#	 puts "Loop #{max_loop} HIGHER: Calculated: #{calculate_secs} Balance: #{balance_secs}"
			end

			total_cost_of_playlist += calculate_secs * start_costs.first.cost_per_sec.to_f
			# puts "Loop #{max_loop}: Secs #{calculate_secs} for rate #{start_costs.first.cost_per_sec.to_f} #{calculate_secs * start_costs.first.cost_per_sec.to_f}"
			# # puts "Loop End #{max_loop} balance #{balance_secs} calculated sec #{calculate_secs} total costs #{total_cost_of_playlist}"
			max_loop += 1 #|| max_loop = 0 if balance_secs > 0
			media_cost_show.loops = max_loop
			media_cost_show.cost_details = start_costs.first.name
			media_cost_show.cost_cal_per_sec = start_costs.first.cost_per_sec.to_f
			media_cost_show.secs_used = calculate_secs
			media_cost_show.secs_bal = balance_secs
			media_cost_show.loop_cost = calculate_secs * start_costs.first.cost_per_sec.to_f

			loop_details << media_cost_show
		end
		# return "Final Cost is #{total_cost_of_playlist} in #{max_loop} loops "
		return loop_details
  end

	############ MediaCostMaster.cost_of_playlist(4,20,0,2500)
	# private
	# def calculate_campaign_cost start_secs, duration_sec
	# 	#check the pricing for start secs
	# 	loop_details = []
	# 	balance_secs = duration_sec
	# 	total_cost_of_playlist = 0
	# 	while balance_secs > 0  do
  #  		start_costs = MediaCostMaster.where("duration_secs <= ?", start_secs).order("duration_secs DESC")
	# 		loop_details << start_costs.first.name
	# 		calculate_secs = start_secs - start_costs.first.ending_sec
	# 		total_cost_of_playlist = calculate_secs * start_costs.first.cost_per_sec
  #  		balance_secs -= calculate_secs
	# 		start_secs = start_costs.first.ending_sec
	# 	end
	# 	return "Final Cost is #{total_cost_of_playlist} and looped through, #{loop_details}"
	# end
	# the following information is collected and used to create campaign
	# campaign_time.start_hour = begin_hr
	# campaign_time.start_min = begin_min
	# campaign_time.start_second = begin_sec
	# campaign_time.start_frames = begin_frame
	# campaign_time.seconds = m.duration_secs
	# create_table "media_cost_masters", force: :cascade do |t|
	# 	t.string   "name"
	# 	t.integer  "duration_secs", precision: 38
	# 	t.decimal  "total_cost",    precision: 10, scale: 2
	# 	t.integer  "media_id",      precision: 38
	# 	t.integer  "str_hr",        precision: 38
	# 	t.integer  "str_min",       precision: 38
	# 	t.integer  "str_sec",       precision: 38
	# 	t.integer  "end_hr",        precision: 38
	# 	t.integer  "end_min",       precision: 38
	# 	t.integer  "end_sec",       precision: 38
	# 	t.text     "description"
	# 	t.datetime "created_at",                             null: false
	# 	t.datetime "updated_at",                             null: false
	# 	t.decimal  "slot_percent",  precision: 5,  scale: 4
	# 	t.integer  "cost_per_sec",  precision: 38
	# 	t.integer  "starting_sec",  precision: 38
	# 	t.integer  "ending_sec",    precision: 38
	# end

end
