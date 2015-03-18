class TapeidsController < ApplicationController
		respond_to :html
  def list
  	@tapeids = TAPEIDS.all
    respond_with(@tapeids)
  end

  def search
  end

  def details
  end
end
