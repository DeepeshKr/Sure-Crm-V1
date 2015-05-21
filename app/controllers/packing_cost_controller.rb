class PackingCostController < ApplicationController
	respond_to :html
  def list
  	@packing_costs = PackingCost.all
  end

  def search
  end

  def details
  end
end
