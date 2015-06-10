class TempinvNewwlsdetController < ApplicationController
	 before_action { protect_controllers(6) } 
	  respond_to :html

  def list
  	@temp_newwlsdet = TEMPINV_NEWWLSDET.all.limit(100)
  	respond_with(@temp_newwlsdet)
  end

  def search
  end

  def details
  end
end
