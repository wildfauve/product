class AlgorithmsController < ApplicationController
  
  def index
    @algs = Algorithm.all
  end
  
  
  def new
    @alg = Algorithm.new
  end
  
  def create
    @alg = SalesProduct.new
    @alg.subscribe(self)
    @alg.create_me(sales_prod: params[:sales_product])
  end
  
  def host_form
  end  
  
  def host_scan
    finder = RemoteAlgorithmFinder.new
    finder.subscribe self
    finder.search(host_name: params[:host_name]) 
  end
  
  def select
    @alg = Algorithm.find(params[:id])
    @alg.select_it
    redirect_to algorithms_path
  end
  
  def remote_algs_success(algs)
    redirect_to algorithms_path
  end
  
end