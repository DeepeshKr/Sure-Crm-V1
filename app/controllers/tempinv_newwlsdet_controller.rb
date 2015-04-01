class TempinvNewwlsdetController < ApplicationController
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
