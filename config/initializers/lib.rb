# require lib modules

# Ruby core_ext
Dir.glob(Rails.root.join('lib/core_ext/ruby/**/*.rb')).sort.each do |filename|
  require filename
end

# Rails core_ext
Dir.glob(Rails.root.join('lib/core_ext/rails/**/*.rb')).sort.each do |filename|
  require filename
end

require 'pagination_helper/pagination_helper'
