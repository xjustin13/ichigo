class ApplicationController < ActionController::Base

  #protect_from_forgery

private

  def breadcrumb(*crumbs)
    @crumbs = crumbs
  end

end
