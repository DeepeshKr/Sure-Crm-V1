module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Sure CRM Telebrands Internal App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  	def row_classname(type = '')
	  switch type
	    if type == "Active"
	      classname = "text-muted"
	    elsif type ==  "Hidden"
	       classname = "text-muted"
	    else "Hidden"
	       classname = "text-muted"
	    end
	   		"class=\"#{classname}\"" unless classname.nil?
	end

	def category_table_row_class(category)
  		{ "Active" => "success", "Hidden" => "text-muted", "Inactive" => "error"}[category]
	end

	def show_div_class(category)
  		{ "Active" => "show", "Hidden" => "hide", "Inactive" => "hide"}[category]
	end

end
