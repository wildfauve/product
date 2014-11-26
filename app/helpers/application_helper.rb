module ApplicationHelper
  
  def alg_list_select
    Algorithm.selected.map{|a| [a.name, a.id]}
  end
  
  
end
