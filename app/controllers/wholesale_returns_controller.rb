class WholesaleReturnsController < ApplicationController
	 before_action { protect_controllers(6) } 
  respond_to :html
  def list
  	 @new_dept = NEW_DEPT.all.order('rdate DESC').limit(100)
  end

  def search
  end

  def details
  end
end
