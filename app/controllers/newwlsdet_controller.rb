class NewwlsdetController < ApplicationController
	before_action { protect_controllers(7) } 
  respond_to :html
  def list
  	@newwlsdet = NEWWLSDET.all.limit(100)
  	respond_with(@newwlsdet)
  end

  def search
  end

  def details
  end
end
