class ProductCostController < ApplicationController
    before_action { protect_controllers_specific(4) } 
	respond_to :html
  def list
    # @con_action = list
     if params.has_key?(:search)
      @prod = params[:search].upcase
      @prodmasters = PRODMASTER.where("prod = ?", @prod)
      @ropmasters = ROPMASTER_NEW.where("prod = ?", @prod)
      @searchvalue = @prod 
    else
      @prodmasters = PRODMASTER.order(:prodname).all.limit(10)
      @ropmasters = ROPMASTER_NEW.all.limit(10)
    
      @searchvalue = @prodmasters.first.prod
    end
  end

  def cost
	@ropmasters = ROPMASTER_NEW.all
  end

  def search

  end

  def details
   #@con_action = details
     
    if params.has_key?(:search)
      @prod = params[:search] #.upcase
      @prodmasters = PRODMASTER.where("prod = ?", @prod)
      @ropmasters = ROPMASTER_NEW.where("prod = ?", @prod)
      @searchvalue = @prod 

    else
      @prodmasters = PRODMASTER.all.limit(1)
      @ropmasters = ROPMASTER_NEW.all.limit(1)
    
      @searchvalue = @prodmasters.first.prod
    end
  	
  end



end
