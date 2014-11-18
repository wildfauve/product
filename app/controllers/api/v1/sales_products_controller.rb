class Api::V1::SalesProductsController < Api::ApplicationController
  
  def index
    @sales_products = SalesProduct.all
  end
  
  def show
    @sales_product = SalesProduct.find(params[:id])
  end
  
  def successful_create_event(party)
  end
  
  def successful_update_event(party)
  end
  
end