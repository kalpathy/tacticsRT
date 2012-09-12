module ContouringSessionHelper

  def print_element(el, lev)
      to_return = ""
      to_return << "<li>"
      to_return << "#{el.name} (#{el.tag}): "
      if not el.children?
        to_return << " #{el.value} "
      else
        to_return << " has " + el.children.size.to_s + " children. "
      end
      to_return <<"</li>\n"
      return to_return
  end
  
  def print_children(el, lev = 0)
    to_return = ""
    to_return << "<ul>\n"
    to_return << print_element(el, lev)
    if el.children?
      c = el.children
      c.each do |child|
        to_return << "<li>"
        to_return << print_children(child, lev+1)
        to_return << "</li>"
      end
    end
    to_return << "</ul>"
    return to_return
  end
  

  
end
