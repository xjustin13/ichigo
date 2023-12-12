class HomeController < ApplicationController

  def index
    @customers = Customer.unscoped.order(%["id" DESC])
  end

end
