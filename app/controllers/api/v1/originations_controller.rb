class Api::V1::OriginationsController < Api::ApplicationController
  
  def index
    @sales_product = SalesProduct.find(params[:sales_product_id])
  end
  
  def create
    @sales_product = SalesProduct.find(params[:sales_product_id])
    @sales_product.subscribe(self)
    @sales_product.buy(buy_msg: params)
  end
  
  def show
    @sales_product = SalesProduct.find(params[:sales_product_id])
    @origination = Origination.find(params[:id])
  end
  
  def destroy
    @buy = Origination.find(params[:id])
    @buy.subscribe(self)
    @buy.remove
  end
  
  def successful_create_event(sales_prod)
    redirect_to sales_products_path
  end
  
  def success_remove_event(sales_prod)
    render json: {status: :ok}, status: :ok
  end
  
  
  def successful_create_event(party)
  end
  
  def successful_update_event(party)
  end
  
  def successful_buy_event(prod)
    @prod = prod
    render status: :created, location: api_v1_sales_product_origination_path(@prod, @prod.purchase)
  end

  def delayed_buy_event(prod)
    @prod = prod
    render status: :accepted, location: approval_api_v1_sales_product_originations_path(@prod, @prod.purchase)
  end

  
end