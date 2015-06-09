class WholesaleReturnsController < ApplicationController
  respond_to :html
  def list
  	 @new_dept = NEW_DEPT.all.order('rdate DESC').limit(100)
  end

  def search
  end

  def details
  end
end
