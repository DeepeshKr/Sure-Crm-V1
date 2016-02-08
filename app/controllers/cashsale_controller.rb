class CashsaleController < ApplicationController
  before_action { protect_controllers(6) }
 respond_to :html

  def index
    @cashsale = CASHSALE.all.order("invoice DESC").limit(100)
    
  end

  def search
  end

  def details
  end
end
