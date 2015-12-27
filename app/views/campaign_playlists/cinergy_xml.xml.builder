#encoding: UTF-8
#cinegy air control playlist
#Timestamp: 23.12.2015 18:11:07.653
xml.instruct! :xml, :version => "1.0"
xml.campaign_playlists do |camp|
    xml.guid camp.generate_unique_secure_token
    xml.version '2'
    xml.TV_Format '720x576 16:9 25i'
    xml.parental_rating 'l'

end
