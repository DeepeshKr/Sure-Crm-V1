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
      xml.src_path c.filename
      xml.descr "Playout file for #{c.filename}"
      xml.block(:name => "Block Name") do
					xml.item(:name => c.product_variant.name, :src_in => c.starttime, :src_out => c.endtime, :in => c.starttime, :out => c.endtime, :type => "clip", :flags => "0") {}
      end
		end
	end
end
