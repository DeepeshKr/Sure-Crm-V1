class TapeiddetController < ApplicationController
			respond_to :html
  def list
  		@tapeids = TAPEIDDET.all
    respond_with(@tapeids)
  end

  def search
  end

  def details
  end
end
