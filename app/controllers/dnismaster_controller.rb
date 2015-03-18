class DnismasterController < ApplicationController
	respond_to :html

  def list
  	@dnismaster = DNISMASTER.all
    respond_with(@dnismaster)
  end

  def search
  	# medialist = Medium.all

  	# medialist.each do |c|
  	# 	dnis = DNISMASTER.where("TATA = ?", c.telephone).pluck("DNIS").first
  	# 	c.update(dnis: dnis)
  	# end

  end

  def details
  end
end



