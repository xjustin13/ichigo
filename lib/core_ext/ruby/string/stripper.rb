module CoreExt
  module Ruby
    module String
      module Stripper
        # strip utf whitespace
        def superstrip
          self.gsub(/(\A[\s　]+|[\s　]+\z)/, '')
        end

        # squish utf whitespace
        def supersquish
          self.superstrip.gsub(/[\s　]+/, ' ')
        end
      end
    end
  end
end
String.send(:prepend, CoreExt::Ruby::String::Stripper)
