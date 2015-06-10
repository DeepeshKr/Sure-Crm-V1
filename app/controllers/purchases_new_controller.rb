class PurchasesNewController < ApplicationController
	 before_action { protect_controllers(6) } 
	respond_to :html
  def list
  	@purchases_new = PURCHASES_NEW.all
    respond_with(@purchases_new)
  end

  def search
  end

  def details
  end
end
