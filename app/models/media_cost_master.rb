class MediaCostMaster < ActiveRecord::Base
# validates :name, presence: true
# validates :total_cost, presence: true
# validates :duration_secs, presence: true
	def media_tape_type
		(self.name + " Min: " + (self.duration_secs / 60).to_s + " Rs: " + total_cost.to_s )
	end
belongs_to :medium, foreign_key: "media_id"

def cost_segment
        return self.total_cost.to_s + " (" + (self.slot_percent * 100).to_s + ")" 
        + "-  (" + (self.str_hr).to_s + ":"  + (self.str_min).to_s   
        + "-  (" + (self.end_hr).to_s + ":"  + (self.end_min).to_s ")" 
    end
end
