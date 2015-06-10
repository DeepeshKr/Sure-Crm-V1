class WholesaleDistributorsController < ApplicationController
	 before_action { protect_controllers(6) } 
  respond_to :html
  def list
  	 @tbpl2003acc = Tbpl2003acc_Master.all.limit(100)
  end

  def search
  end

  def details
  end
end
