class SalesProductsController < ApplicationController
  
  def index
    @sales_products = SalesProduct.all
  end
  
  def new
    @sales_product = SalesProduct.new
  end
  
  def create
    @sales_product = SalesProduct.new
    @sales_product.subscribe(self)
    @sales_product.create_me(sales_prod: params[:sales_product])
  end
  
  def successful_create_event(sales_prod)
    redirect_to sales_products_path
  end
end
