class TasksController < ApplicationController
  
  def index
    @tasks = Task.all
  end
  
  def new
    @sales_product = SalesProduct.new
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def create
    @sales_product = SalesProduct.new
    @sales_product.subscribe(self)
    @sales_product.create_me(sales_prod: params[:sales_product])
  end

  def edit
    @sales_product = SalesProduct.find(params[:id])
  end

  def update
    @sales_product = SalesProduct.find(params[:id])
    @sales_product.subscribe(self)
    @sales_product.update_me(sales_prod: params[:sales_product])
  end

  def destroy
    @sales_product = SalesProduct.find(params[:id])
    @sales_product.delete
    redirect_to sales_products_path
  end
    
  def successful_sales_product_create_event(sales_prod)
    redirect_to sales_products_path
  end

  def successful_sales_product_update_event(sales_prod)
    redirect_to sales_products_path
  end

  
end
