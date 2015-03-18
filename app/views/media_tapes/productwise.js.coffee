$("#campaign_playlist_tape_id").empty()
  .append("<%= escape_javascript(render(:partial => @media_tapes)) %>")

$("#campaign_playlist_name").val('<%= @name %>')

$("#campaign_playlist_internaltapeid").val('<%= @internaltapeid %>')

$("#campaign_playlist_filename").val('<%= @filename %>')

$("#campaign_playlist_duration_secs").val('<%= @duration_secs %>')

$("#campaign_playlist_cost").val('<%= @cost %>')

