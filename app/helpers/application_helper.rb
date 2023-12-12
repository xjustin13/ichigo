module ApplicationHelper
  include PaginationHelper

  def breadcrumb_tag
    return if @crumbs.blank?
    content_tag(:ul, :class=>'breadcrumb') do
      @crumbs.each do |crumb|
        if crumb.is_a?(Array)
          concat content_tag(:li, link_to(crumb[0], crumb[1]) + '&nbsp;&raquo;&nbsp;'.html_safe)
        else
          concat content_tag(:li, crumb)
        end
      end
    end
  end

end
