class OrdersController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @orders   = @customer.orders.since_last_year.order(%["created_at" DESC])
    breadcrumb(['Home', root_path],
               ["#{@customer.name} [ID#: #{@customer.id}]", customer_path(@customer)],
               'orders')
    respond_to do |format|
      format.html
      format.json {render :json=>@orders}
    end
  end

  def create
    @order = Order.new(params[:order])
    if @order.save
      render(:json=>@order)
    else
      render(:json=>@order.errors, :status=>400)
    end
  end

end
