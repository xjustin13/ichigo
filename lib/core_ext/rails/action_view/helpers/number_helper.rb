# Assume cents for :en locale
module ActionView::Helpers::NumberHelper
  _number_to_currency_ = instance_method(:number_to_currency)

  # method overwrite
  define_method(:number_to_currency) do |number, options={}|
    if (options[:locale] || I18n.locale) == :en
      # assume cents
      raise(ArgumentError, "not an Integer: #{number.inspect}") unless number.is_a?(Integer)
      dollars = number / 100.0
      if !!options[:strip_insignificant_zeros]
        # only apply to whole dollar amounts
        if dollars.to_i == dollars
          options[:strip_insignificant_zeros] = true
        else
          options[:strip_insignificant_zeros] = false
        end
      end
      _number_to_currency_.bind(self).call(dollars, options)
    else
      _number_to_currency_.bind(self).call(number, options)
    end
  end

end
