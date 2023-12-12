module CoreExt
  module Rails
    module ActiveRecord
      module Base
        # superstrip and supersquish ActiveRecord attributes.
        module Stripper
          def self.prepended(model) # :nodoc:
            model.send(:prepend, InstanceMethods)
          end

          module InstanceMethods
            def write_attribute(attr_name, value)
              _value = clean_value(attr_name, value)
              super(attr_name, _value)
            end
          end

          private

          def clean_value(attr_name, value)
            # Don't apply to :password_digest
            return value if attr_name.to_sym == :password_digest
            # Don't apply to non-Strings and :binary column types
            return value if (!value.is_a?(String) || self.column_for_attribute(attr_name).type == :binary)

            _value = value.superstrip

            # supersquish non-text columns
            if self.column_for_attribute(attr_name).type != :text
              _value = _value.supersquish
            end

            # nullify empty strings
            _value.presence
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send(:prepend, CoreExt::Rails::ActiveRecord::Base::Stripper)
