class VppController < ApplicationController
	respond_to :html
  def list
  	 @vpp = VPP.all.limit(100)
  	 respond_with(@vpp)
  end

  def search
  end

  def details
  end
end
