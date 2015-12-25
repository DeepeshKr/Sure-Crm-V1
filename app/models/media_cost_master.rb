class MediaCostMaster < ActiveRecord::Base
# validates :name, presence: true
# validates :total_cost, presence: true
# validates :duration_secs, presence: true
	def media_tape_type
		(self.name + " Min: " + (self.duration_secs / 60).to_s + " Rs: " + total_cost.to_s )
	end
belongs_to :medium, foreign_key: "media_id"

	def cost_segment
    return self.total_cost.to_s + " - " + (self.slot_percent * 100).to_s + "%" + " - (" + (self.str_hr).to_s + ":"  + (self.str_min).to_s  + "-" + (self.end_hr).to_s + ":"  + (self.end_min).to_s + ")"
	end

	after_save :recalculate_media_total_cost

	def recalculate_media_total_cost
		hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f

		hbn_list = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
		hbn_list.each do |hbn|
		 new_total = hbn_media_cost * hbn.slot_percent
		 hbn.update(total_cost: new_total)
		end

	end

end
