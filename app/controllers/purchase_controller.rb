class PurchaseController < ApplicationController
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
