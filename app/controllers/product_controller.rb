class ProductController < ApplicationController
	
   skip_before_action :require_login, only: [:home, :help, :contact]
  def home
  end

  def help
  end
  
  def about
  end

  def contact
  end
end
