class CustomersController < ApplicationController

  def show
    @customer = Customer.find(params[:id])
    breadcrumb(['Home', root_path], "#{@customer.name} [ID#: #{@customer.id}]")
    respond_to do |format|
      format.html
      format.json {render :json=>@customer}
    end
  end

end
