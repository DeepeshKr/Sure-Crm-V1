class BProdmasterController < ApplicationController
		respond_to :html
  def list
  	@b_prodmaster = B_PRODMASTER.all
    respond_with(@b_prodmaster)
  end

  def search

  end

  def details
  	 @prod = "Selected Nothing"
  		if params.has_key?(:gprod)
	  	 	@prodmasters = PRODMASTER.where("prod = ?", params[:gprod])
	  		@ropmasters = ROPMASTER_NEW.where("prod = ?", params[:gprod])
	  	 	@prod = params[:gprod]
	   		respond_with(@prodmasters, @ropmasters)
	  	end
	end
end
