require 'csv'
module CoreExt
  module Rails
    module ActiveRecord
      module Base
        # exports table data to yaml file
        module Exporter
          def self.prepended(model) # :nodoc:
            # switch self to model's singleton class
            class << model
              self.send(:prepend, ClassMethods)
            end
          end

          module ClassMethods
            # use it like this:
            # class User
            #   attr_not_exportable :created_at, :updated_at
            # end
            def attr_not_exportable(*args)
              @attr_not_exportable = args
            end

            def export(options={})
              rejects = Array(@attr_not_exportable).map(&:to_s)
              if !!options[:csv]
                filename = "#{::Rails.root.join(self.table_name)}.csv"
                headers  = self.column_names - rejects
                CSV.open(filename, 'w', :write_headers=>true, :headers=>headers) do |csv|
                  self.unscoped.find_each do |obj|
                    csv << obj.attributes.values_at(*headers)
                  end
                end
              else
                filename = "#{::Rails.root.join(self.table_name)}.yml"
                File.open(filename, 'w') do |file|
                  self.unscoped.find_each do |obj|
                    file.write({"#{self.name.underscore}_#{obj.id}"=>obj.attributes.except(*rejects).reject{|k,v| v.nil?}}.to_yaml.gsub("---\n", ''))
                  end
                end
              end
              "Wrote #{self.unscoped.count} #{self.name.pluralize.underscore} to #{filename}"
            end
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send(:prepend, CoreExt::Rails::ActiveRecord::Base::Exporter)
