$("#campaign_playlist_tape_id").empty()
  .append("<%= escape_javascript(render(:partial => @media_tape_heads)) %>")

$("#campaign_playlist_duration_secs").val('<%= @duration_secs %>')