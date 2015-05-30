class PackingCostController < ApplicationController
	 before_action { protect_controllers(5) } 
	respond_to :html
  def list
  	#@packing_costs = PACKINGCOST.all
  	@packing_costs = PACKCOST.all
  end

  def search
  end

  def details
  end
end
