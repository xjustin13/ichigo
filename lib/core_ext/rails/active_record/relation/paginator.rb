module CoreExt
  module Rails
    module ActiveRecord
      module Relation
        # pagination
        module Paginator
          DEFAULT_PER_PAGE = 10
          DEFAULT_PAGE_CAP = 10
          PAGES_PER_GROUP = 10

          def self.prepended(model)
            model.send(:prepend, InstanceMethods)
          end

          module InstanceMethods
            def page(num, options={})
              # switch self to instance's singleton class
              class << self
                self.send(:prepend, SingletonMethods)
              end
              if options.has_key?(:per_page)
                raise(ArgumentError, ':per_page MUST BE A POSITIVE INTEGER!') unless (options[:per_page].is_a?(Integer) && options[:per_page] > 0)
              end
              if options.has_key?(:page_cap)
                unless options[:page_cap] == false
                  raise(ArgumentError, ':page_cap MUST BE A POSITIVE INTEGER OR FALSE!') unless (options[:page_cap].is_a?(Integer) && options[:page_cap] > 0)
                end
              end

              @current_page = !!num ? num.to_i : 1
              @per_page = options[:per_page] || DEFAULT_PER_PAGE
              if options[:page_cap] == false
                page_cap = false
              else
                page_cap = options[:page_cap] || DEFAULT_PAGE_CAP
              end
              @total_count = self.count
              int = [(@total_count.to_f / @per_page).ceil, page_cap].reject(&:blank?).min
              @total_pages = int.zero? ? 1 : int
              @page_groups = [*1..@total_pages].in_groups_of(PAGES_PER_GROUP, false)
              @current_page_group = @page_groups.find{|group| group.include?(@current_page)}
              fetch_records_for_current_page
            end
          end

          module SingletonMethods
            def total_count
              @total_count
            end

            def total_pages
              @total_pages
            end

            def paginate?
              @total_pages > 1
            end

            def current_page
              @current_page
            end

            def previous_page
              @current_page - 1
            end

            def next_page
              @current_page + 1
            end

            def first_page?
              @current_page == 1
            end

            def last_page?
              @current_page == @total_pages
            end

            def current_page_group
              @current_page_group
            end

            def first_page_group?
              @current_page_group == @page_groups.first
            end

            def last_page_group?
              @current_page_group == @page_groups.last
            end

            private

            def fetch_records_for_current_page
              if @current_page < 1 || @current_page > @total_pages
                self.where('1=0') #return zero records
              else
                self.limit(@per_page).offset((@current_page - 1)*@per_page)
              end
            end
          end
        end
      end
    end
  end
end
ActiveRecord::Relation.send(:prepend, CoreExt::Rails::ActiveRecord::Relation::Paginator)
