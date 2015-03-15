# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# app/assets/javascripts/welcome.js.coffee
  

$ ->
  $(document).on 'change', '#campaign_playlist_productvariantid', (evt) ->
    $.ajax '/mediatapesforproducts',
      type: 'GET'
      dataType: 'script'
      data: {
        product_variant_id: $("#campaign_playlist_productvariantid option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")



$ ->
  $(document).on 'change', '#campaign_playlist_tape_id', (evt) ->
    $.ajax '/mediatapesdetails',
      type: 'GET'
      dataType: 'script'
      data: {
        tape_id: $("#campaign_playlist_tape_id option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")