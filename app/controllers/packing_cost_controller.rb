class PackingCostController < ApplicationController
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
