$("#addon_product_list_id").empty().append("<%= escape_javascript(render(:partial => @product_master_add_ons)) %>")

