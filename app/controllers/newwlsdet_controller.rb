class NewwlsdetController < ApplicationController
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
