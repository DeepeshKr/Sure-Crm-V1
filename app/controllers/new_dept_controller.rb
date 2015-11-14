class NewDeptController < ApplicationController
  before_action { protect_controllers(7) } 
  respond_to :html
  def list
  	@new_depts = NEW_DEPT.all.limit(100)
  	respond_with(@new_depts)
  end

  def search
  end

  def details
  end
end
