class Api::V1::OriginationsController < Api::ApplicationController
  
  def index
  end
  
  def create
    @sales_product = SalesProduct.find(params[:sales_product_id])
    @sales_product.subscribe(self)
    @sales_product.buy(buy_msg: params)
  end
  
  def successful_create_event(party)
  end
  
  def successful_update_event(party)
  end
  
  def successful_buy_event(prod)
    @prod = prod
    render status: :created, location: api_v1_sales_product_origination_path(@prod, @prod.purchase)
  end
  
end