class ProjectController < ApplicationController
   include FooTime
  #<%= javascript_include_tag 'https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js' %>

    #before_action { protect_controllers(20) }
     skip_before_action :require_login, only: [:home, :help, :contact]
  def home
    @current_time = (Time.zone.now + 330.minutes)
    if logged_in?
        @current_user_id = current_user.id 
        @empcode = current_user.employee_code
        @employee_id = Employee.where(employeecode: @empcode).first.id

        @app_feature_requests = AppFeatureRequest.where(request_by: @employee_id, app_feature_type_id: 10000)
        @app_feature_errors = AppFeatureRequest.where(request_by: @employee_id, app_feature_type_id: 10001)

       if current_user.role == 10022 || current_user.role == 10162
         @app_upload_requests = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10010)
         @app_upload_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10010)

       end
    end


    @timenow = foo_hello_time


  end

  def help
    lines = params[:lines]

      @stderr_logs = `tail -n #{lines} shared/log/puma.stderr.log`
      @stdout_logs = `tail -n #{lines} shared/log/puma.stdout.log`
      @development_logs = `tail -n #{lines} log/development.log`

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

  def longtable
    #https://github.com/laertejjunior/freezeheader
  end
  def demo

          # require 'gruff'
          #
          # g = Gruff::Line.new
          # g.title = "Wow!  Look at this #{@timenow}! "
          # g.labels = { 0 => '5/6', 1 => '5/15', 2 => '5/24', 3 => '5/30', 4 => '6/4',
          #              5 => '6/12', 6 => '6/21', 7 => '6/28' }
          # g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
          # g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
          # g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
          # g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
          # g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
          # g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]
          #
          # g.marker_count = 1
          # g.write(File.join(Rails.root, "app", "assets", "graph_new.png"))


          #g.write('new_exciting.png')
           #g.write("/app/assets/new_exciting.png")

          #bar_chart.write(File.join(Rails.root, "public", "system", "graph", "lawfirm_#{@lawyer.id}.png"))


          # Your first formulation, image_url('logo.png'), is correct. If the image is found, it will generate the path /assets/logo.png (plus a hash in production). However, if Rails cannot find the image that you named, it will fall back to /images/logo.png.
          #
          # The next question is: why isn't Rails finding your image? If you put it in app/assets/images/logo.png, then you should be able to access it by going to http://localhost:3000/assets/logo.png.
          #
          # If that works, but your CSS isn't updating, you may need to clear the cache. Delete tmp/cache/assets from your project directory and restart the server (webrick, etc.).
          #
          # If that fails, you can also try just using background-image: url(logo.png); That will cause your CSS to look for files with the same relative path (which in this case is /assets).

  end
end
