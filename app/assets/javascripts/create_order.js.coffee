# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#order_line_product_list_id', (evt) ->
    $.ajax '/addonproductlist',
      type: 'GET'
      dataType: 'script'
      data: {product_list_id: $("#order_line_product_list_id option:selected").val()}
  
$ ->
    $(document).on 'change', '#productlist', (evt) ->
      $.ajax '/addonproductlist',
        type: 'GET'
        dataType: 'script'
        data: {product_list_id: $('#id').val()} 

