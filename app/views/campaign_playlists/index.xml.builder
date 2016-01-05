xml.instruct! :xml, :version => "1.0"
xml.comment! "CinegyPlayout File #{@timestamp}"
xml.mcrs_playlist do
  xml.guid @guid1
	@campaign_playlists.each do |c|
		xml.program(:name => c.product_variant.name, :duration => "00:00:00") do
			xml.name c.product_variant.name
			xml.guid @guid2 #.generate_unique_secure_token
			xml.version 2
			xml.TV_Format '720x576 16:9 25i'
      xml.program(:name => "New Program") do
        xml.guid @guid3
        xml.detailKey '_4addd2a4'
        xml.block(:name => "Block Name") do
          xml.guid @guid4
          xml.item(:name => c.product_variant.name, :src_in => c.starttime, :src_out => c.endtime, :in => c.starttime, :out => c.endtime, :type => "clip", :flags => "0") {
            xml.guid @guid5
            xml.FrameRate 25
            xml.Aspect '16:9'
            xml.timeline(:duration => c.duration_secs, :version => "4") {
              xml.group(:type => "video", :width => "1920", :height => "1080", :aspect => "16:9", :framerate => "25", :progressive => "n"){
                xml.track {
                  xml.clip(:srcref => "0", :start => c.starttime, :stop => c.endtime, :mstart => c.starttime, :mstop => c.endtime){
                    xml.quality(:src => c.filename, :id => "0")
                  }
                }
              }
              xml.group(:type => "audio", :channels => "2"){
                xml.track {
                  xml.clip(:srcref => "1", :start => c.starttime, :stop => c.endtime, :mstart => c.starttime, :mstop => c.endtime){
                      xml.quality(:src => c.filename, :id =>"0")
                  }
                }
              }
            } #timeline
            xml.src_path c.filename
            xml.src_modified @created_time
            xml.AudioMatrix(:name => "Default 8", :description => "Default mapping, 8 channels, direct",
			:value => "1,0,0,0,0,0,0,0;1,0,0,0,0,0,0,0;0,1,0,0,0,0,0,0;0,1,0,0,0,0,0,0;0,0,1,0,0,0,0,0;0,0,1,0,0,0,0,0;0,0,0,1,0,0,0,0;0,0,0,1,0,0,0,0", :default => "True")
            xml.ActiveAspect '16:9'
          }
          end
        end
      end
		end
end
#end
