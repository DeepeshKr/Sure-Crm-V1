class ProjectController < ApplicationController
  
  #before_action { protect_controllers(20) } 
     skip_before_action :require_login, only: [:home, :help, :contact]
  def home
    @timenow = Time.zone.now + 330.minutes
    @dateandtime = Date.today.in_time_zone + 330.minutes
    @datewithouttime = Date.today.in_time_zone + 330.minutes
    @datewithouttime = (330.minutes).from_now.to_date
  end

  def help
  end
  
  def about
  end

  def contact
  end
  
  def dropdown
  end
  
  def update_text
    @city_text = params[:city_name]
  end
  
  

  def luhn
    code = params[:code]
    s1 = s2 = 0
    code.to_s.reverse.chars.each_slice(2) do |odd, even| 
    s1 += odd.to_i
 
    double = even.to_i * 2
    double -= 9 if double >= 10
    s2 += double
  end
    p = (s1 + s2) % 10 == 0
    @cardno = code
    if (s1 + s2) % 10 == 0
      @color = "green"
      @valid = "is a Valid Card No"
    else
      @color = "red"
       @valid = "is an In-Valid Card No"
    end
 
  end
 
end
