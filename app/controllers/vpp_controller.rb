class VppController < ApplicationController
   before_action { protect_controllers(6) } 
	respond_to :html
  def list
  	#order_number
  	 @vpp = VPP.all.order("custref DESC").limit(100)
  	 respond_with(@vpp)
  end

  def search
  end

  def details
  end
end
