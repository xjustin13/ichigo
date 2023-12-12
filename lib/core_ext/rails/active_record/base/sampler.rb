module CoreExt
  module Rails
    module ActiveRecord
      module Base
        # take a random database sample of any ActiveRecord model
        module Sampler
          def self.prepended(model) # :nodoc:
            # switch self to model's singleton class
            class << model
              self.send(:prepend, ClassMethods)
            end
          end

          module ClassMethods

            def sample(n=1)
              adapter = ::ActiveRecord::Base.connection.adapter_name
              if ['MySQL', 'Mysql2'].include?(adapter)
                self.order('RAND()').limit(n)
              else
                self.order('RANDOM()').limit(n)
              end
            end

            # fast sampling (requires PostgreSQL tsm_system_rows extension)
            def tsample(n=1)
              self.from(%["#{self.table_name}" TABLESAMPLE SYSTEM_ROWS(#{n}*10)]).order('RANDOM()').limit(n)
            end

          end
        end
      end
    end
  end
end
ActiveRecord::Base.send(:prepend, CoreExt::Rails::ActiveRecord::Base::Sampler)
