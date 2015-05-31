class MediaCostMaster < ActiveRecord::Base
# validates :name, presence: true
# validates :total_cost, presence: true
# validates :duration_secs, presence: true
	def media_tape_type
		self.name + " Min: " + (self.duration_secs / 60).to_s + " Rs: " + cost_per_sec.to_s
	end
belongs_to :medium, foreign_key: "media_id"
end
