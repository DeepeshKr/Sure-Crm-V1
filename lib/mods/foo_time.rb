module FooTime
  def foo_hello_time
  	time_now = (Time.zone.now + 330.minutes).strftime("%d-%b-%Y %H:%M")
    "hello the time now is #{time_now}"
  end
end