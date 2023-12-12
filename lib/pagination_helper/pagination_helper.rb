# Requires Bootstrap v2.3.2
# include this module inside of module ApplicationHelper
module PaginationHelper
  def self.included(model)
    model.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def pagination_tag(relation)
      return unless relation.paginate?
      content_tag(:div, :class=>'pagination pagination-centered') do
        content_tag(:ul) do
          if relation.first_page?
            concat content_tag(:li, content_tag(:span, 'Prev'), :class=>'disabled')
          else
            concat content_tag(:li, link_to('Prev', request.query_parameters.merge(:page=>relation.previous_page)))
          end
          concat(content_tag(:li, content_tag(:span, '...'), :class=>'disabled')) unless relation.first_page_group?
          Array(relation.current_page_group).each do |page|
            if relation.current_page == page
              concat content_tag(:li, content_tag(:span, page), :class=>'active')
            else
              concat content_tag(:li, link_to(page, request.query_parameters.merge(:page=>page)))
            end
          end
          concat(content_tag(:li, content_tag(:span, '...'), :class=>'disabled')) unless relation.last_page_group?
          if relation.last_page?
            concat content_tag(:li, content_tag(:span, 'Next'), :class=>'disabled')
          else
            concat content_tag(:li, link_to('Next', request.query_parameters.merge(:page=>relation.next_page)))
          end
        end
      end
    end
  end
end
