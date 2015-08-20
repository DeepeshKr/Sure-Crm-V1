class PageTrail < ActiveRecord::Base
	 belongs_to :order_master, foreign_key: "order_id"
	  belongs_to :employee, foreign_key: "employee_id"

  #after_create :updatetiming # :creator
  #after_save :updatetiming 
	  private
	def updatetiming
		#select the order id
		if self.order_id.present?
			
			#get the previous order
			previous_trails = PageTrail.where(order_id: self.order_id).where.not(id: self.id).order("id desc")

			if previous_trails.present?

				previous_trail= previous_trails.first
				timing  = self.created_at - previous_trail.created_at
				previous_trail.update(duration_secs: timing)
			end


		end
	end
end
