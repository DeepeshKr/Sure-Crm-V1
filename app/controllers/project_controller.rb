class ProjectController < ApplicationController
  
  #before_action { protect_controllers(20) } 
     skip_before_action :require_login, only: [:home, :help, :contact]
  def home
    @timenow = (Time.zone.now + 330.minutes).strftime("%d-%b-%Y %H:%M")
    
      # require 'gruff'

      # g = Gruff::Line.new
      # g.title = 'Wow!  Look at this!'
      # g.labels = { 0 => '5/6', 1 => '5/15', 2 => '5/24', 3 => '5/30', 4 => '6/4',
      #              5 => '6/12', 6 => '6/21', 7 => '6/28' }
      # g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
      # g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
      # g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
      # g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
      # g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
      # g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]

      # g.marker_count = 1
      # g.write('exciting.png')
      #g.write("/home/deepesh/telebrands-projects/sure-crm-1/lib/assets/graphs/exciting.png")
  end

  def help
  end
  
  def about
    # stuff = ['chod', :mint, "wall", :ball]
    # @list = "NA"
    # stuff.find_all do |word|
    #    if word[0..1] == "wa"
    #      @list += word[0..1]
    #   end
    # end

    n = "10 10 10"
    @test = n
      @values = n.split #.('')
      @n1 = @values[0].to_i
      @n2 = @values[1].to_i
      @n3 = @values[2].to_i

      if (@n1 == @n2) && (@n2 == @n3)
          @list = "An Equvilateral Triangle"
      elsif (@n1 == @n2) || (@n2 == @n3) || (@n1 == @n3)
          @list = "An Isoceles Triangle"
      else
          @list = "Scalene Triangle"    
      end

      @states = State.all.order("name")
     @timenow = (Time.zone.now + 330.minutes).strftime("%d-%b-%Y %H:%M")
  end

  def contact
     @timenow = (Time.zone.now + 330.minutes).strftime("%d-%b-%Y %H:%M")
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
