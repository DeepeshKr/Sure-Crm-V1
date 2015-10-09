class DealTranController < ApplicationController
before_action { protect_controllers(6) } 
respond_to :html
  def list 
  	 @dealtran = DEALTRAN.all.order("custref DESC").limit(100)
  	 respond_with(@dealtran)
  end

  def search
  end

  def details
  end
end
