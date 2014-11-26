class OriginationsController < ApplicationController
  
  def approval
    @origination = Origination.find(params[:id])
    @origination.subscribe self
    @origination.approve
  end
  
  def destroy
    @origination = Origination.find(params[:id])
    @origination.delete
    redirect_to tasks_path
  end
  
  def successful_origination_approval(orig)
    redirect_to tasks_path
  end
  
end