class ProductCostController < ApplicationController
	respond_to :html
  def list
	@prodmasters = PRODMASTER.order(:prodname).all
    respond_with(@prodmasters)
  end

  def cost
	@ropmasters = ROPMASTER_NEW.all
    respond_with(@ropmasters)
  end

  def search
  end

  def details
  	 @prod = "Selected Nothing"
  	if params.has_key?(:prod)
  	 	@prodmasters = PRODMASTER.where("prod = ?", params[:prod])
  	@ropmasters = ROPMASTER_NEW.where("prod = ?", params[:prod])
  	 @prod = params[:prod]
   respond_with(@prodmasters, @ropmasters)

  	end
  	
  end



end
